*&---------------------------------------------------------------------*
*& Include          ZSELECTION_SCR
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK blk_1 WITH FRAME TITLE TEXT-001.

  PARAMETERS: r_wood  RADIOBUTTON GROUP rbg1 USER-COMMAND ucom,
              r_steel RADIOBUTTON GROUP rbg1.


  SELECTION-SCREEN SKIP 1.

  PARAMETERS: p_file TYPE string OBLIGATORY.

  SELECTION-SCREEN SKIP 1.

  PARAMETERS: c_test AS CHECKBOX USER-COMMAND ucom_1.

  SELECTION-SCREEN: PUSHBUTTON 40(10) p_button USER-COMMAND EXE VISIBLE LENGTH 10.

  SELECTION-SCREEN SKIP 1.

SELECTION-SCREEN END OF BLOCK blk_1.
