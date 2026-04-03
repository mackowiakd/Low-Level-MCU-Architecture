#include <p18f45k22.inc>

; ==========================================================
; KONFIGURACJA
; ==========================================================
    CONFIG FOSC = INTIO67   ; Oscylator Wewnêtrzny
    CONFIG WDTEN = OFF      ; Watchdog Wy³¹czony
    CONFIG MCLRE = INTMCLR  ; Reset Wewnêtrzny
    CONFIG LVP = OFF 		;else PIC rezerw pin RB5 jako specjalne wejœcie "PGM" (Low Voltage Programming Enable).

; ==========================================================
; ZMIENNE
; ==========================================================
   CBLOCK 0x20              ; Rozpocznij blok zmiennych od adresu 0x20 (User RAM)
        FAZA                ; Zmienna steruj¹ca animacj¹ (0 lub 1)
        DISP_FLAG           ; Zmienna steruj¹ca multipleksowaniem (0=Prawy, 1=Lewy)
    ENDC                    ; Koniec bloku zmiennych
; ==========================================================
; WEKTORY
; ==========================================================
    ORG 0x0000
    GOTO START

    ORG 0x0008
    GOTO ISR

; ==========================================================
; START
; ==========================================================
    ORG 0x0020
START:
    ; 1. Porty
	MOVLB   0xF             ; Wybierz Bank 15 (tam s¹ rejestry ANSEL w tym modelu).
    CLRF    ANSELA          ; Wpisz 0 do ANSELA -> Port A jako CYFROWY (nie analogowy).
    CLRF    ANSELD          ; Wpisz 0 do ANSELD -> Port D jako CYFROWY.
    MOVLB   0x0             ; Powrót do Banku 0 (Access Bank) 	

    CLRF    TRISA           ; 0 = Output. Port A (sterowanie tranzystorami) jako Wyjœcia.
    CLRF    TRISD           ; 0 = Output. Port D (segmenty wyœwietlacza) jako Wyjœcia.

    ; 2. Timer0 - SZYBKI (Multipleksowanie)
   	; Bit 7 (TMR0ON)=1: W³¹cz Timer.
    ; Bit 6 (T08BIT)=1: Tryb 8-bitowy (liczy do 255).
    ; Bit 5 (T0CS)=0:   Zegar wewnêtrzny (Fosc/4).
    ; Bit 3 (PSA)=0:    Preskaler W³¹czony.
    ; Bity 2-0 (T0PS)=000: Preskaler 1:2.
    MOVLW   b'11000000'
    MOVWF   T0CON

    ; 3. Timer1 - WOLNY (Animacja)
    ; Bit 7-6 (TMR1CS)=00: Zegar wewnêtrzny Fosc/4 (System Clock).
    ; Bit 5-4 (T1CKPS)=11: Preskaler 1:8 (Maksymalne zwolnienie).
    ; Bit 1 (RD16)=0:      Tryb odczytu 8-bitowego (standardowy).
    ; Bit 0 (TMR1ON)=1:    W³¹cz Timer.
    MOVLW   b'00110001'     ; Ustawienia T1CON
    MOVWF   T1CON

    ; 4. Przerwania
    BSF     INTCON, TMR0IE     ; Zezwól na przerwania od Timera 0 (G³ówny Timer).
    BSF     PIE1, TMR1IE    ; Zezwól na przerwania od Timera 1 
    BSF     INTCON, PEIE    ; Peripheral Interrupt Enable
    BSF     INTCON, GIE     ; Global Interrupt Enable - G³ówny w³¹cznik przerwañ .

    ; 5. Inicjalizacja
    CLRF    FAZA
    CLRF    DISP_FLAG

MAIN_LOOP:
    BRA     MAIN_LOOP       ; Pusta pêtla -> czekamy na przerwania


; ==========================================================
; OBS£UGA PRZERWANIA (DISPATCHER)
; ==========================================================
ISR:
    ; Sprawdza Ÿród³o przerwania

    ; --- 1. Czy to Timer0? (Odœwie¿anie) ---
    BTFSC   INTCON, TMR0IF
    CALL    OBSLUGA_EKRANU

    ; --- 2. Czy to Timer1? (Animacja) ---
    BTFSC   PIR1, TMR1IF
    CALL    ZMIANA_ANIMACJI

    RETFIE  FAST

; ----------------------------------------------------------
; ZADANIE 1: ODŒWIE¯ANIE EKRANU
; ----------------------------------------------------------
OBSLUGA_EKRANU:
    BCF     INTCON, TMR0IF  ; Skasuj flagê T0
    
    CLRF    LATD
    CLRF    LATA

    BTG     DISP_FLAG, 0    ; Zmieñ wyœwietlacz

    BTFSC   DISP_FLAG, 0
    BRA     OBSLUZ_LEWY     ; 1->Skok do obs³ugi Lewego
    BRA     OBSLUZ_PRAWY    ; 0-> Skok do obs³ugi Prawego
    ; Uwaga: Tamte procedury musz¹ zakoñczyæ siê RETURN!

; --- Obs³uga Prawego ---
OBSLUZ_PRAWY:
    BSF     LATA, 0         ; W³¹cz zasilanie 
    
    BTFSC   FAZA, 0
    BRA     PRAWY_STAN2
    
PRAWY_STAN1:
    MOVLW   b'00000001'     ; A (Góra)
    MOVWF   LATD
    RETURN                  ; <--- WA¯NE: WRÓÆ DO ISR

PRAWY_STAN2:
    MOVLW   b'00001000'     ; D (Dó³)
    MOVWF   LATD
    RETURN                  ; <--- WA¯NE: WRÓÆ DO ISR

; --- Obs³uga Lewego ---
OBSLUZ_LEWY:
    BSF     LATA, 3         ; W³¹cz Lewy
    
    BTFSC   FAZA, 0
    BRA     LEWY_STAN2
    
LEWY_STAN1:
    MOVLW   b'00001000'     ; D (Dó³ - bo na odwrót)
    MOVWF   LATD
    RETURN                  ; <--- WA¯NE: WRÓÆ DO ISR

LEWY_STAN2:
    MOVLW   b'00000001'     ; A (Góra - bo na odwrót)
    MOVWF   LATD
    RETURN                  ; <--- WA¯NE: WRÓÆ DO ISR


; ----------------------------------------------------------
; ZADANIE 2: ZMIANA ANIMACJI (TIMER 1)
; ----------------------------------------------------------
ZMIANA_ANIMACJI:
    BCF     PIR1, TMR1IF    ; Skasuj flagê T1
    
    ; Prze³adowanie Timera1 (¿eby odliczal. 0.5s) -> 65536 - 15625 = 49911 (0xC2F7).
    ; Wartoœæ startowa 0xC2F7 (dla 0.5s przy 1MHz/4/8)
    MOVLW   high 0xC2F7     
    MOVWF   TMR1H
    MOVLW   low  0xC2F7
    MOVWF   TMR1L          ; Wpis do dolnego rejestru (zatrzaskuje oba)
    
    ; Zmieñ klatkê
    BTG     FAZA, 0
    
    RETURN                  ; <--- WA¯NE: WRÓÆ DO ISR
    
    END