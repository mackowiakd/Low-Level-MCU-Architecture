//////////////////////////////////////////////////////////////////////////////
// Laboratory AVR Microcontrollers Part3
// Program template for lab 23
// Please fill in this information before starting coding 
// Authors: Dominika Maćkowiak
//
// Group:   2
// Section: 3
//
// Task: 10. Please turn off all diodes at the start of the program. Wait for a button press. Table copying will
//      begin once any button connected to port A is pressed. Write a program that copies bytes from
//      TAB_ROM to TAB_RAM, transferring one byte at each even address. If TAB_ROM is larger than
//      TAB_RAM, the program will keep copying bytes to the end of TAB_ROM and then loop back to the
//      start of TAB_RAM as necessary. Display each copied byte on the diodes connected to port C.
//      Pause for about 750ms between displaying each byte. Turn on the LED connected to port
//      B.7 after the program finishes. After that: Turn LED connected to Port B.7 exactly: for 750ms -
//      ON, next 500ms - OFF, next for 750ms - ON and then switch to OFF.
//
// Todo: add Timer and interrupts
//
// Version: 5.0
//////////////////////////////////////////////////////////////////////////////
.nolist ; quartz assumption 4Mhz
.include "m2560def.inc"
;//////////////////////////////////////////////////////////////////////////////
.list
.equ xlength = 100

;//////////////////////////////////////////////////////////////////////////////
; EEPROM - data non volatile memory segment 
.ESEG 

;//////////////////////////////////////////////////////////////////////////////
; StaticRAM - data memory segment
.DSEG 
.ORG 0x200 ; may be omitted this is default value

; Destination table
TAB_RAM: .BYTE xlength
TimeCounter: .byte 1 

;//////////////////////////////////////////////////////////////////////////////
; CODE - Program memory segment
.CSEG  
.org 0x0000 
jmp RESET   ; Reset Handler

.org OC1Aaddr        ; Timer1 Compare Match A Interrupt Vector
rjmp TIM1_COMPA_ISR

; Interrupts vector table - unused interrupts
jmp EXT_INT0    ; IRQ0 Handler
jmp EXT_INT1    ; IRQ1 Handler
jmp EXT_INT2    ; IRQ2 Handler
jmp EXT_INT3    ; IRQ3 Handler
jmp EXT_INT4    ; IRQ4 Handler
jmp EXT_INT5    ; IRQ5 Handler
jmp EXT_INT6    ; IRQ6 Handler
jmp EXT_INT7    ; IRQ7 Handler
jmp HPCINT0     ; PCINT0 Handler
jmp HPCINT1     ; PCINT1 Handler
jmp HPCINT2     ; PCINT2 Handler
jmp WDT         ; WDT Handler
jmp TIM2_COMPA  ; Timer2 CompareA Handler
jmp TIM2_COMPB  ; Timer2 CompareB Handler
jmp TIM2_OVF    ; Timer2 Overflow Handler
jmp TIM1_CAPT   ; Timer1 Capture Handler
jmp TIM1_C0MPB  ; Timer1 CompareB Handler
jmp TIM1_COMPC  ; Timer1 CompareC Handler
jmp TIM1_0VF    ; Timer1 Overflow Handler
jmp TIM0_COMPA  ; Timer0 CompareA Handler
jmp TIM0_COMPB  ; Timer0 CompareB Handler
jmp TIM0_OVF    ; Timer0 Overflow Handler
jmp SPI_STC     ; SPI Transfer Complete Handler
jmp USART0_RXC  ; USART0 RX Complete Handler
jmp USART0_UDRE ; USART0,UDR Empty Handler
jmp USART0_TXC  ; USART0 TX Complete Handler
jmp ANA_COMP    ; Analog Comparator Handler
jmp HADC        ; ADC Conversion Complete Handler
jmp EE_RDY      ; EEPROM Ready Handler
jmp TIM3_CAPT   ; Timer3 Capture Handler
jmp TIM3_COMPA  ; Timer3 CompareA Handler
jmp TIM3_COMPB  ; Timer3 CompareB Handler
jmp TIM3_COMPC  ; Timer3 CompareC Handler
jmp TIM3_OVF    ; Timer3 Overflow Handler
jmp USART1_RXC  ; USART1 RX Complete Handler
jmp USART1_UDRE ; USART1,UDR Empty Handler
jmp USART1_TXC  ; USART1 TX Complete Handler
jmp TWI         ; Two-wire Serial Interface Interrupt Handler
jmp SPM_RDY     ; SPM Ready Handler
jmp TIM4_CAPT   ; Timer4 Capture Handler
jmp TIM4_COMPA  ; Timer4 CompareA Handler
jmp TIM4_COMPB  ; Timer4 CompareB Handler
jmp TIM4_COMPC  ; Timer4 CompareC Handler
jmp TIM4_OVF    ; Timer4 Overlflow Handler
jmp TIM5_CAPT   ; Timer5 Capture Handler
jmp TIM5_COMPA  ; Timer5 CompareA Handler
jmp TIM5_COMPB  ; Timer5 CompareB Handler
jmp TIM5_COMPC  ; Timer5 CompareC Handler
jmp TIM5_OVF    ; Timer5 Overlflow Handler
jmp USART2_RXC  ; USART2 RX Complete Handler
jmp USART2_UDRE ; USART2,UDR Empty Handler
jmp USART2_TXC  ; USART2 TX Complete Handler
jmp USART3_RXC  ; USART3 RX Complete Handler
jmp USART3_UDRE ; USART3,UDR Empty Handler
jmp USART3_TXC  ; USART3 TX Complete Handler

//////////////////////////////////////////////////////////////////////////////
; Interrupt Handlers (Unused)
EXT_INT0:   
EXT_INT1:   
EXT_INT2:   
EXT_INT3:   
EXT_INT4:   
EXT_INT5:   
EXT_INT6:   
EXT_INT7:   
HPCINT0:        
HPCINT1:        
HPCINT2:        
WDT:        
TIM2_COMPA: 
TIM2_COMPB: 
TIM2_OVF:   
TIM1_CAPT:  
TIM1_C0MPB: 
TIM1_COMPC: 
TIM1_0VF:   
TIM0_COMPA: 
TIM0_COMPB: 
TIM0_OVF:   
SPI_STC:    
USART0_RXC: 
USART0_UDRE:
USART0_TXC: 
ANA_COMP:   
HADC:       
EE_RDY:     
TIM3_CAPT:  
TIM3_COMPA: 
TIM3_COMPB: 
TIM3_COMPC: 
TIM3_OVF:   
USART1_RXC: 
USART1_UDRE:
USART1_TXC: 
TWI:        
SPM_RDY:    
TIM4_CAPT:  
TIM4_COMPA: 
TIM4_COMPB: 
TIM4_COMPC: 
TIM4_OVF:   
TIM5_CAPT:  
TIM5_COMPA: 
TIM5_COMPB: 
TIM5_COMPC: 
TIM5_OVF:   
USART2_RXC: 
USART2_UDRE:
USART2_TXC: 
USART3_RXC: 
USART3_UDRE:
USART3_TXC: 
    reti        ; Return from all unused interrupts

;//////////////////////////////////////////////////////////////////////////////
; Program start
RESET:
    cli         ; Disable all interrupts
    
    ; Set stack pointer to top of RAM
    ldi R16, HIGH(RAMEND)
    out SPH, R16
    ldi R16, LOW(RAMEND)
    out SPL, R16

  ; --- 1. PEŁNA INICJALIZACJA PORTÓW (Zgodnie z konfiguracją zworek) ---

    ; --- PORT A: Wejście (Buttons) ---
    ; SV2 ON -> Przyciski aktywne
    ldi r16, 0x00
    out DDRA, r16        ; Kierunek: Input
    ldi r16, 0xFF
    out PORTA, r16       ; Pull-up Enabled (wymagane dla przycisków)

    ; --- PORT B: Mieszany (Diody + Zworka SV5 na PB0) ---
    ; PB7, PB6, PB5 -> Diody (Output)
    ; PB0 -> Przycisk PCINT0 (Input - Safety!)
    ; Reszta -> Input Hi-Z
    ldi r16, 0xE0        ; 11100000 (Tylko starsze 3 bity to wyjścia)
    out DDRB, r16
    ldi r16, 0x00        ; 00000000 (Diody zgaszone - Active High)
    out PORTB, r16 

    ; --- PORT C: Wyjście (Diody Danych) ---
    ; Zworka na "L" -> Active Low
    ldi r16, 0xFF
    out DDRC, r16        ; Kierunek: Output
    ldi r16, 0xFF        ; Stan wysoki -> Diody zgaszone 
    out PORTC, r16

    ; --- PORT E: Wejście (Zworki na INT4/PE4 i INT5/PE5) ---
    ; Zworki SV3 i SV4 są włożone -> Piny połączone z przyciskami.
    ; Muszą być WEJŚCIAMI, aby uniknąć zwarcia!
    ldi r16, 0x00
    out DDRE, r16        ; Kierunek: Input (Bezpieczne dla INT4/INT5)
    out PORTE, r16       ; Stan: Hi-Z (No pull-up, wymóg dla nieużywanych)

    ; --- PORT D: Wejście (Zworki INT0/INT1 wiszą) ---
    ; Skoro wiszą, bezpiecznie dajemy Input Hi-Z
    ldi r16, 0x00
    out DDRD, r16
    out PORTD, r16

    ; --- POZOSTAŁE PORTY (F, G, H, J, K, L) -> Input Hi-Z ---
    ; Rejestr r16 mamy wyzerowany (0x00)
    
    ; Standardowe (OUT)
    out DDRF, r16
    out PORTF, r16
    
    out DDRG, r16
    out PORTG, r16

    ; Rozszerzone (STS)
    sts DDRH, r16
    sts PORTH, r16
    
    sts DDRJ, r16
    sts PORTJ, r16
    
    sts DDRK, r16
    sts PORTK, r16
    
    sts DDRL, r16
    sts PORTL, r16

    

    ; --- 2. Configuration of TIMER1 (CTC Mode, 10ms Interrupt) ---
    ldi r16, 0
    sts TCCR1A, r16
    
    ; Prescaler 64 (CS11 & CS10) | CTC Mode (WGM12)
    ldi r16, (1 << WGM12) | (1 << CS11) | (1 << CS10)
    sts TCCR1B, r16

    ; Set Compare Match value for 10ms
	; Timer liczy od 0, więc wpisujemy N-1: 2500 - 1 = 2499
    ; 2499 = 0x09C3
    ldi r16, 0x09   
    sts OCR1AH, r16
    ldi r16, 0xC3   
    sts OCR1AL, r16 

    ; Enable Timer1 Compare Match A Interrupt
    ldi r16, (1 << OCIE1A)
    sts TIMSK1, r16

    ; --- 3. Load initial values of index registers ---
    ldi XL, low(xlength)
    ldi XH, high(xlength)
    ldi YL, low(TAB_RAM)
    ldi YH, high(TAB_RAM)
    ldi ZL, low(TAB_ROM<<1)
    ldi ZH, high(TAB_ROM<<1)
    ldi r20, byte3(TAB_ROM<<1)
    out RAMPZ, r20
    
    ldi r19, high(TAB_RAM + xlength)  ; High byte of RAM end address
    ldi r21, low(TAB_RAM + xlength)   ; Low byte of RAM end address 
    ldi r17, 0x00                     ; Terminator value (0)
    ldi r23, 0xFF                     ; Mask for Active Low LED display

    sei                               ; Enable global interrupts

CheckButton:
	in r18, PINA        
    cpi r18, 0xFF        
    breq CheckButton    
    rcall Delay20ms     ; Ta funkcja zeruje r19!
    
    ; >>>Odtwarzanie limitow bufora po powrocie z Delay <<<
    ldi r19, high(TAB_RAM + xlength) 
    ldi r21, low(TAB_RAM + xlength)


Main:
    ; --- KROK 1: Pobierz bajt danych (parzysty) ---
    elpm r16, Z       ; Czytamy BEZ plusa (+)
    
    ; --- RĘCZNA INKREMENTACJA 1 (Z = Z + 1) ---
    subi ZL, -1       ; ZL = ZL + 1
    sbci ZH, -1       ; ZH = ZH + 0 + Carry
    
    ; >>> POPRAWKA: Sprawdzamy flagę ZERO, a nie Carry! <<<
    brne SkipR1       ; Jeśli wynik ZH:ZL NIE jest zerem, skocz dalej
    
    in r24, RAMPZ     ; Jeśli tu jesteśmy, Z stało się 0000 -> Zmień stronę
    inc r24
    out RAMPZ, r24
SkipR1:

    ; --- KROK 2: Sprawdź koniec tablicy (0x00, 0x00) ---
    cpse r16, r17     
    rjmp DataFound    
    elpm r22, Z       ; Podgląd następnego bajtu
    cpse r22, r17     
    rjmp DataFound    
    rjmp EndSequence  

DataFound:
    ; --- KROK 3: Zapis do RAM i wyświetlanie ---
    rcall CheckAndWrap
    st Y+, r16        
    
    mov r24, r16
    eor r24, r23      
    out PORTC, r24
    
    ldi r24, 75      ; 10ms *75 =750ms 
    rcall WaitTicks

    ; --- KROK 4: Pominięcie bajtu nieparzystego (Z = Z + 1) ---
    subi ZL, -1
    sbci ZH, -1
    
    ; >>> POPRAWKA: Ponownie sprawdzamy flagę ZERO <<<
    brne SkipR2
    
    in r24, RAMPZ
    inc r24
    out RAMPZ, r24
SkipR2:

    rjmp Main


; Subroutine to check RAM wrap-around
CheckAndWrap:
    cp YH, r19			; Porównaj starszą część adresu Y (YH) z limitem (r19)
    brlo Return
    cp YL, r21
    brlo Return
    ldi YL, low(TAB_RAM)
    ldi YH, high(TAB_RAM)
Return:
    ret

EndSequence:
    ; Turn off Port C LEDs before end sequence
    ldi r16, 0xFF      ; 0xFF = All LEDs OFF (Active Low)
    out PORTC, r16

    ; --- STEP 1: ON for 750ms ---
    sbi PORTB, 7       ; Turn ON PB7
    ldi r24, 75        ; 75 * 10ms = 750ms
    rcall WaitTicks

    ; --- STEP 2: OFF for 500ms ---
    cbi PORTB, 7       ; Turn OFF PB7
    ldi r24, 50        ; 50 * 10ms = 500ms
    rcall WaitTicks

    ; --- STEP 3: ON for 750ms ---
    sbi PORTB, 7       ; Turn ON PB7
    ldi r24, 75        ; 75 * 10ms = 750ms
    rcall WaitTicks

    ; --- STEP 4: Switch to OFF ---
    cbi PORTB, 7       ; Turn OFF PB7 permanently

StopForever:
    rjmp StopForever   ; Halt program

; --- Timer Helper Functions ---

WaitTicks:
    cli
    clr r25
    sts TimeCounter, r25 ; Reset software counter
    sts TCNT1H, r25      ; Reset hardware timer
    sts TCNT1L, r25      
    sei

WaitLoop:
    lds r25, TimeCounter
    cp r25, r24         ; Compare current ticks with target
    brlo WaitLoop       ; Wait if current < target
    ret

TIM1_COMPA_ISR:
    push r16
    in r16, SREG
    push r16

    lds r16, TimeCounter
    inc r16             ; Increment tick counter (10ms resolution)
    sts TimeCounter, r16

    pop r16
    out SREG, r16
    pop r16
    reti

; --- Button Debounce Function ---
Delay20ms:
 ldi r18, 7      ; outer loop count
OuterLoop:
 ldi r19, 126    ; middle loop count
MiddleLoop:
 ldi r20, 120    ; inner loop count
InnerLoop:
 dec r20         
 brne InnerLoop  
 dec r19         
 brne MiddleLoop 
 dec r18         
 brne OuterLoop  
 ret 


//------------------------------------------------------------------------------
// Table Declaration -  place here test values
//
; ==============================================================================
; TEST 1: Standardowy test logiczny (Parzystość i Wzorce)
; Cel: Sprawdzenie czy pomija nieparzyste bajty i wyświetla wzorce na LED.
; ==============================================================================
/*
   
  TAB_ROM: 	.db 	0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x1F
			.db 	0x00,0x00
*/

; ==============================================================================
; TEST 2: Bufor RAM mniejszy niż dane (ROM > RAM Wrap-around)
; Cel: Sprawdzenie zawijania bufora kołowego (Circular Buffer).
; UWAGA: Ustaw w kodzie .equ xlength = 5
; Oczekiwany wynik w RAM: 11 22 33 44 55 (pełny), potem 66 nadpisuje 11.
; ==============================================================================
/*
TAB_ROM:
    .db     0x11, 0xFF      ; 1. Bajt do RAM (0x11)
    .db     0x22, 0xFF      ; 2. Bajt do RAM (0x22)
    .db     0x33, 0xFF      ; 3. Bajt do RAM (0x33)
    .db     0x44, 0xFF      ; 4. Bajt do RAM (0x44)
    .db     0x55, 0xFF      ; 5. Bajt do RAM (0x55) - Koniec bufora (dla xlength=5)
    .db     0x66, 0xFF      ; 6. Bajt - Powinien trafić na początek RAM (Wrap)
    .db     0x00, 0x00      ; KONIEC
*/

; ==============================================================================
; TEST 3: Pusta Tablica (Empty ROM)
; Cel: Sprawdzenie reakcji na brak danych.
; Oczekiwany wynik: Program natychmiast kończy działanie (EndSequence), brak kopiowania.
; ==============================================================================
/*
TAB_ROM:
    .db     0x00, 0x00      ; Podwójne zero na starcie = Natychmiastowy koniec
*/

; ==============================================================================
; TEST 4: Pamięć Wysoka (High Memory > 64KB)
; Cel: Sprawdzenie działania rejestru RAMPZ i instrukcji ELPM.
; Oczekiwany wynik: Poprawne skopiowanie danych AA, BB, CC, DD, EE do RAM.
; ==============================================================================
/*
.org 0x8000                 ; 
TAB_ROM:
    .db     0xAA, 0x01      ; Dane testowe w wysokiej pamięci
    .db     0xBB, 0x02
    .db     0xCC, 0x03
	.db		0xDD, 0x04
	.db		0xEE, 0x05
    .db     0x00, 0x00      


//example template ROM

.org 0x8000
TAB_ROM:

    .db 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F
    .db 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E, 0x1F
    .db 0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x2D, 0x2E, 0x2F
    .db 0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3A, 0x3B, 0x3C, 0x3D, 0x3E, 0x3F
    .db 0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49, 0x4A, 0x4B, 0x4C, 0x4D, 0x4E, 0x4F
    .db 0x50, 0x51, 0x52, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58, 0x59, 0x5A, 0x5B, 0x5C, 0x5D, 0x5E, 0x5F
    .db 0x60, 0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69, 0x6A, 0x6B, 0x6C, 0x6D, 0x6E, 0x6F
    .db 0x70, 0x71, 0x72, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79, 0x7A, 0x7B, 0x7C, 0x7D, 0x7E, 0x7F
    .db 0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87, 0x88, 0x89, 0x8A, 0x8B, 0x8C, 0x8D, 0x8E, 0x8F
    .db 0x90, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0x98, 0x99, 0x9A, 0x9B, 0x9C, 0x9D, 0x9E, 0x9F
    .db 0xA0, 0xA1, 0xA2, 0xA3, 0xA4, 0xA5, 0xA6, 0xA7, 0xA8, 0xA9, 0xAA, 0xAB, 0xAC, 0xAD, 0xAE, 0xAF
    .db 0xB0, 0xB1, 0xB2, 0xB3, 0xB4, 0xB5, 0xB6, 0xB7, 0xB8, 0xB9, 0xBA, 0xBB, 0xBC, 0xBD, 0xBE, 0xBF
    .db 0xC0, 0xC1, 0xC2, 0xC3, 0xC4, 0xC5, 0xC6, 0xC7, 0xC8, 0xC9, 0xCA, 0xCB, 0xCC, 0xCD, 0xCE, 0xCF
    .db 0xD0, 0xD1, 0xD2, 0xD3, 0xD4, 0xD5, 0xD6, 0xD7, 0xD8, 0xD9, 0xDA, 0xDB, 0xDC, 0xDD, 0xDE, 0xDF
    .db 0xE0, 0xE1, 0xE2, 0xE3, 0xE4, 0xE5, 0xE6, 0xE7, 0xE8, 0xE9, 0xEA, 0xEB, 0xEC, 0xED, 0xEE, 0xEF
    .db 0xF0, 0xF1, 0xF2, 0xF3, 0xF4, 0xF5, 0xF6, 0xF7, 0xF8, 0xF9, 0xFA, 0xFB, 0xFC, 0xFD, 0xFE, 0xFF
    .db 0x00, 0x00



; ==============================================================================
; TEST 5: RAM SIZE 300 PROOF (Full 300 Bytes Data)
; Lokalizacja ROM: 0x2000 (Bezpieczny środek pamięci, RAMPZ nie bierze udziału)
; Cel: Udowodnienie, że Y (RAM) przechodzi płynnie przez adres 0x02FF -> 0x0300.
; Oczekiwany wynik: W RAM ciągła sekwencja liczb od 01 do FF, potem 00 do 2C.
; ==============================================================================
.org 0x2000
TAB_ROM:
    ; --- Część 1: Liczby od 0x01 do 0xFF (255 bajtów) ---
    .db 0x01, 0xFF, 0x02, 0xFF, 0x03, 0xFF, 0x04, 0xFF, 0x05, 0xFF, 0x06, 0xFF, 0x07, 0xFF, 0x08, 0xFF
    .db 0x09, 0xFF, 0x0A, 0xFF, 0x0B, 0xFF, 0x0C, 0xFF, 0x0D, 0xFF, 0x0E, 0xFF, 0x0F, 0xFF, 0x10, 0xFF
    .db 0x11, 0xFF, 0x12, 0xFF, 0x13, 0xFF, 0x14, 0xFF, 0x15, 0xFF, 0x16, 0xFF, 0x17, 0xFF, 0x18, 0xFF
    .db 0x19, 0xFF, 0x1A, 0xFF, 0x1B, 0xFF, 0x1C, 0xFF, 0x1D, 0xFF, 0x1E, 0xFF, 0x1F, 0xFF, 0x20, 0xFF
    .db 0x21, 0xFF, 0x22, 0xFF, 0x23, 0xFF, 0x24, 0xFF, 0x25, 0xFF, 0x26, 0xFF, 0x27, 0xFF, 0x28, 0xFF
    .db 0x29, 0xFF, 0x2A, 0xFF, 0x2B, 0xFF, 0x2C, 0xFF, 0x2D, 0xFF, 0x2E, 0xFF, 0x2F, 0xFF, 0x30, 0xFF
    .db 0x31, 0xFF, 0x32, 0xFF, 0x33, 0xFF, 0x34, 0xFF, 0x35, 0xFF, 0x36, 0xFF, 0x37, 0xFF, 0x38, 0xFF
    .db 0x39, 0xFF, 0x3A, 0xFF, 0x3B, 0xFF, 0x3C, 0xFF, 0x3D, 0xFF, 0x3E, 0xFF, 0x3F, 0xFF, 0x40, 0xFF
    .db 0x41, 0xFF, 0x42, 0xFF, 0x43, 0xFF, 0x44, 0xFF, 0x45, 0xFF, 0x46, 0xFF, 0x47, 0xFF, 0x48, 0xFF
    .db 0x49, 0xFF, 0x4A, 0xFF, 0x4B, 0xFF, 0x4C, 0xFF, 0x4D, 0xFF, 0x4E, 0xFF, 0x4F, 0xFF, 0x50, 0xFF
    .db 0x51, 0xFF, 0x52, 0xFF, 0x53, 0xFF, 0x54, 0xFF, 0x55, 0xFF, 0x56, 0xFF, 0x57, 0xFF, 0x58, 0xFF
    .db 0x59, 0xFF, 0x5A, 0xFF, 0x5B, 0xFF, 0x5C, 0xFF, 0x5D, 0xFF, 0x5E, 0xFF, 0x5F, 0xFF, 0x60, 0xFF
    .db 0x61, 0xFF, 0x62, 0xFF, 0x63, 0xFF, 0x64, 0xFF, 0x65, 0xFF, 0x66, 0xFF, 0x67, 0xFF, 0x68, 0xFF
    .db 0x69, 0xFF, 0x6A, 0xFF, 0x6B, 0xFF, 0x6C, 0xFF, 0x6D, 0xFF, 0x6E, 0xFF, 0x6F, 0xFF, 0x70, 0xFF
    .db 0x71, 0xFF, 0x72, 0xFF, 0x73, 0xFF, 0x74, 0xFF, 0x75, 0xFF, 0x76, 0xFF, 0x77, 0xFF, 0x78, 0xFF
    .db 0x79, 0xFF, 0x7A, 0xFF, 0x7B, 0xFF, 0x7C, 0xFF, 0x7D, 0xFF, 0x7E, 0xFF, 0x7F, 0xFF, 0x80, 0xFF
    .db 0x81, 0xFF, 0x82, 0xFF, 0x83, 0xFF, 0x84, 0xFF, 0x85, 0xFF, 0x86, 0xFF, 0x87, 0xFF, 0x88, 0xFF
    .db 0x89, 0xFF, 0x8A, 0xFF, 0x8B, 0xFF, 0x8C, 0xFF, 0x8D, 0xFF, 0x8E, 0xFF, 0x8F, 0xFF, 0x90, 0xFF
    .db 0x91, 0xFF, 0x92, 0xFF, 0x93, 0xFF, 0x94, 0xFF, 0x95, 0xFF, 0x96, 0xFF, 0x97, 0xFF, 0x98, 0xFF
    .db 0x99, 0xFF, 0x9A, 0xFF, 0x9B, 0xFF, 0x9C, 0xFF, 0x9D, 0xFF, 0x9E, 0xFF, 0x9F, 0xFF, 0xA0, 0xFF
    .db 0xA1, 0xFF, 0xA2, 0xFF, 0xA3, 0xFF, 0xA4, 0xFF, 0xA5, 0xFF, 0xA6, 0xFF, 0xA7, 0xFF, 0xA8, 0xFF
    .db 0xA9, 0xFF, 0xAA, 0xFF, 0xAB, 0xFF, 0xAC, 0xFF, 0xAD, 0xFF, 0xAE, 0xFF, 0xAF, 0xFF, 0xB0, 0xFF
    .db 0xB1, 0xFF, 0xB2, 0xFF, 0xB3, 0xFF, 0xB4, 0xFF, 0xB5, 0xFF, 0xB6, 0xFF, 0xB7, 0xFF, 0xB8, 0xFF
    .db 0xB9, 0xFF, 0xBA, 0xFF, 0xBB, 0xFF, 0xBC, 0xFF, 0xBD, 0xFF, 0xBE, 0xFF, 0xBF, 0xFF, 0xC0, 0xFF
    .db 0xC1, 0xFF, 0xC2, 0xFF, 0xC3, 0xFF, 0xC4, 0xFF, 0xC5, 0xFF, 0xC6, 0xFF, 0xC7, 0xFF, 0xC8, 0xFF
    .db 0xC9, 0xFF, 0xCA, 0xFF, 0xCB, 0xFF, 0xCC, 0xFF, 0xCD, 0xFF, 0xCE, 0xFF, 0xCF, 0xFF, 0xD0, 0xFF
    .db 0xD1, 0xFF, 0xD2, 0xFF, 0xD3, 0xFF, 0xD4, 0xFF, 0xD5, 0xFF, 0xD6, 0xFF, 0xD7, 0xFF, 0xD8, 0xFF
    .db 0xD9, 0xFF, 0xDA, 0xFF, 0xDB, 0xFF, 0xDC, 0xFF, 0xDD, 0xFF, 0xDE, 0xFF, 0xDF, 0xFF, 0xE0, 0xFF
    .db 0xE1, 0xFF, 0xE2, 0xFF, 0xE3, 0xFF, 0xE4, 0xFF, 0xE5, 0xFF, 0xE6, 0xFF, 0xE7, 0xFF, 0xE8, 0xFF
    .db 0xE9, 0xFF, 0xEA, 0xFF, 0xEB, 0xFF, 0xEC, 0xFF, 0xED, 0xFF, 0xEE, 0xFF, 0xEF, 0xFF, 0xF0, 0xFF
    .db 0xF1, 0xFF, 0xF2, 0xFF, 0xF3, 0xFF, 0xF4, 0xFF, 0xF5, 0xFF, 0xF6, 0xFF, 0xF7, 0xFF, 0xF8, 0xFF
    .db 0xF9, 0xFF, 0xFA, 0xFF, 0xFB, 0xFF, 0xFC, 0xFF, 0xFD, 0xFF, 0xFE, 0xFF, 0xFF, 0xFF
    
    ; --- Część 2: Brakujące 45 bajtów (od 0x00 do 0x2C), żeby dobić do 300 ---
    .db 0x00, 0xFF, 0x01, 0xFF, 0x02, 0xFF, 0x03, 0xFF, 0x04, 0xFF, 0x05, 0xFF, 0x06, 0xFF, 0x07, 0xFF
    .db 0x08, 0xFF, 0x09, 0xFF, 0x0A, 0xFF, 0x0B, 0xFF, 0x0C, 0xFF, 0x0D, 0xFF, 0x0E, 0xFF, 0x0F, 0xFF
    .db 0x10, 0xFF, 0x11, 0xFF, 0x12, 0xFF, 0x13, 0xFF, 0x14, 0xFF, 0x15, 0xFF, 0x16, 0xFF, 0x17, 0xFF
    .db 0x18, 0xFF, 0x19, 0xFF, 0x1A, 0xFF, 0x1B, 0xFF, 0x1C, 0xFF, 0x1D, 0xFF, 0x1E, 0xFF, 0x1F, 0xFF
    .db 0x20, 0xFF, 0x21, 0xFF, 0x22, 0xFF, 0x23, 0xFF, 0x24, 0xFF, 0x25, 0xFF, 0x26, 0xFF, 0x27, 0xFF
    .db 0x28, 0xFF, 0x29, 0xFF, 0x2A, 0xFF, 0x2B, 0xFF, 0x2C, 0xFF
    
    ; KONIEC DANYCH
    .db 0x00, 0x00

*/
; ==============================================================================
; TEST 6: Page Boundary Crossing 
; Start ROM: 0x7F80 (Word) -> 0xFF00 (Byte)
; Granica: 0xFFFE (Strona 0) -> 0x0000 (Strona 1)
; Cel: Weryfikacja poprawki (FIX) dla rejestru RAMPZ.
; Oczekiwany wynik: Płynne przejście w RAM z wartości FE na AA.
; ==============================================================================
; ==============================================================================
; TEST 6 (CLEAN): Surgical Page Boundary Crossing
; Start ROM: 0x7FFA (Word) -> 0xFFF4 (Byte)
; To jest zaledwie 12 bajtów przed końcem segmentu pamięci!
; Cel: Wyraźne zobaczenie momentu przejścia bez śmieci (FF).
; ==============================================================================

.org 0x7FFA         ; Adres bajtowy = 0xFFF4
TAB_ROM:
    ; --- KONIEC STRONY 0 (RAMPZ się jeszcze nie zmienia) ---
    ; Format: .db DANA, ŚMIEĆ (zamiast FF dałem liczby, żeby je odróżnić)
    
    .db 0xE1, 0x11  ; Adres FFF4 (Dana E1), FFF5 (Śmieć 11)
    .db 0xE2, 0x22  ; Adres FFF6 (Dana E2), FFF7 (Śmieć 22)
    .db 0xE3, 0x33  ; Adres FFF8 (Dana E3), FFF9 (Śmieć 33)
    .db 0xE4, 0x44  ; Adres FFFA (Dana E4), FFFB (Śmieć 44)
    .db 0xE5, 0x55  ; Adres FFFC (Dana E5), FFFD (Śmieć 55)
    
    ; !!! KRYTYCZNY MOMENT !!!
    ; Adres FFFE (Ostatnia DANA starej strony) -> FFFF (Ostatni ŚMIEĆ)
    ; Tutaj po odczycie 0x66 rejestr Z przekręci się z FFFF na 0000!
    .db 0xFE, 0x66  
    
    ; --- POCZĄTEK STRONY 1 (Tutaj RAMPZ musi być już podbity) ---
    ; Adres 0000 (w nowym segmencie)
    .db 0xAA, 0x77  ; Adres 0000 (Dana AA), 0001 (Śmieć 77)
    .db 0xBB, 0x88  ; Adres 0002 (Dana BB), 0003 (Śmieć 88)
    .db 0xCC, 0x99  
    
    ; Koniec danych
    .db 0x00, 0x00

	

; ==============================================================================
; TEST 7: Minimal RAM Buffer (Circular Buffer Stress Test)
; Cel: Weryfikacja poprawnego zawijania przy bardzo małej liczbie komórek.
; Dane w ROM (użyteczne): 0x11, 0x22, 0x33, 0x44, 0x55 (5 bajtów)
; Rozmiar RAM: 3 bajty
; ==============================================================================
/*
.org 0x3000         ; Dowolna bezpieczna lokalizacja
TAB_ROM:
    .db 0x11, 0xFF  ; 1. bajt -> RAM[0]
    .db 0x22, 0xFF  ; 2. bajt -> RAM[1]
    .db 0x33, 0xFF  ; 3. bajt -> RAM[2] (bufor pełny)
    .db 0x44, 0xFF  ; 4. bajt -> powrót i nadpisanie RAM[0]
    .db 0x55, 0xFF  ; 5. bajt -> nadpisanie RAM[1]
    .db 0x00, 0x00  ; KONIEC


; ==============================================================================
; TEST 8: RAM Size 100 (Intra-page Wrap-around)
; Cel: Sprawdzenie zawijania, gdy starszy bajt adresu (YH) nie ulega zmianie.
; Dane: 105 bajtów użytecznych (0x01 ... 0x69)
; Oczekiwany wynik: Dane 0x65-0x69 nadpiszą początek bufora (0x01-0x05).
; ==============================================================================
.org 0x4000

TAB_ROM:
    ; Każda linia poniżej to 10 bajtów użytecznych (i 10 śmieci 0xFF)
    .db 0x01, 0xFF, 0x02, 0xFF, 0x03, 0xFF, 0x04, 0xFF, 0x05, 0xFF, 0x06, 0xFF, 0x07, 0xFF, 0x08, 0xFF, 0x09, 0xFF, 0x0A, 0xFF ; 10
    .db 0x0B, 0xFF, 0x0C, 0xFF, 0x0D, 0xFF, 0x0E, 0xFF, 0x0F, 0xFF, 0x10, 0xFF, 0x11, 0xFF, 0x12, 0xFF, 0x13, 0xFF, 0x14, 0xFF ; 20
    .db 0x15, 0xFF, 0x16, 0xFF, 0x17, 0xFF, 0x18, 0xFF, 0x19, 0xFF, 0x1A, 0xFF, 0x1B, 0xFF, 0x1C, 0xFF, 0x1D, 0xFF, 0x1E, 0xFF ; 30
    .db 0x1F, 0xFF, 0x20, 0xFF, 0x21, 0xFF, 0x22, 0xFF, 0x23, 0xFF, 0x24, 0xFF, 0x25, 0xFF, 0x26, 0xFF, 0x27, 0xFF, 0x28, 0xFF ; 40
    .db 0x29, 0xFF, 0x2A, 0xFF, 0x2B, 0xFF, 0x2C, 0xFF, 0x2D, 0xFF, 0x2E, 0xFF, 0x2F, 0xFF, 0x30, 0xFF, 0x31, 0xFF, 0x32, 0xFF ; 50
    .db 0x33, 0xFF, 0x34, 0xFF, 0x35, 0xFF, 0x36, 0xFF, 0x37, 0xFF, 0x38, 0xFF, 0x39, 0xFF, 0x3A, 0xFF, 0x3B, 0xFF, 0x3C, 0xFF ; 60
    .db 0x3D, 0xFF, 0x3E, 0xFF, 0x3F, 0xFF, 0x40, 0xFF, 0x41, 0xFF, 0x42, 0xFF, 0x43, 0xFF, 0x44, 0xFF, 0x45, 0xFF, 0x46, 0xFF ; 70
    .db 0x47, 0xFF, 0x48, 0xFF, 0x49, 0xFF, 0x4A, 0xFF, 0x4B, 0xFF, 0x4C, 0xFF, 0x4D, 0xFF, 0x4E, 0xFF, 0x4F, 0xFF, 0x50, 0xFF ; 80
    .db 0x51, 0xFF, 0x52, 0xFF, 0x53, 0xFF, 0x54, 0xFF, 0x55, 0xFF, 0x56, 0xFF, 0x57, 0xFF, 0x58, 0xFF, 0x59, 0xFF, 0x5A, 0xFF ; 90
    .db 0x5B, 0xFF, 0x5C, 0xFF, 0x5D, 0xFF, 0x5E, 0xFF, 0x5F, 0xFF, 0x60, 0xFF, 0x61, 0xFF, 0x62, 0xFF, 0x63, 0xFF, 0x64, 0xFF ; 100
    
    ; Ostatnie 5 bajtów (nadpiszą początek bufora)
    .db 0x65, 0xFF, 0x66, 0xFF, 0x67, 0xFF, 0x68, 0xFF, 0x69, 0xFF ; 105
    .db 0x00, 0x00
*/
; ==============================================================================
; TEST 9: RAM Buffer > ROM Data (Short Table Test)
; Cel: Weryfikacja zatrzymania pętli po napotkaniu 0x00, 0x00 przed zapełnieniem RAM.
; Dane w ROM (użyteczne): 0xA1, 0xB2, 0xC3, 0xD4 (4 bajty)
; Rozmiar RAM: 10 bajtów
; ==============================================================================
/*
.org 0x5000         ; Bezpieczna lokalizacja w pamięci Flash
TAB_ROM:
    .db 0xA1, 0xFF  ; 1. bajt użyteczny -> trafi do TAB_RAM[0]
    .db 0xB2, 0xFF  ; 2. bajt użyteczny -> trafi do TAB_RAM[1]
    .db 0xC3, 0xFF  ; 3. bajt użyteczny -> trafi do TAB_RAM[2]
    .db 0xD4, 0xFF  ; 4. bajt użyteczny -> trafi do TAB_RAM[3]
    
    ; Znacznik końca danych (terminator)
    .db 0x00, 0x00
*/


.EXIT
//------------------------------------------------------------------------------
