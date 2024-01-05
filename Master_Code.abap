*&---------------------------------------------------------------------*
*& Report ZPLANTM_301
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zplantm_301.

INCLUDE zdata_definition.
INCLUDE zselection_scr.
INCLUDE zvalidation.


START-OF-SELECTION.
  PERFORM application_data USING p_file.
  PERFORM call_bapi.
