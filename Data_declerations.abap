*&---------------------------------------------------------------------*
*& Include          ZDATA_DEFINITION
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_steel, ""Steel Pole structure.
         qmart TYPE qmart,
         qmnum TYPE qmnum,
         qmtxt TYPE qmtxt,
         sttxt TYPE qmsttxt,
         astxt TYPE co_asttx,
         tplnr TYPE tplnr,
         equnr TYPE equnr,
         ingrp TYPE ingrp,
         gewrk TYPE gewrk,
         qmnam TYPE qmnam,
         erdat TYPE icrdt1,
         ernam TYPE icrna,
         qmdat TYPE qmdat,
         mzeit TYPE mzeit,
         strmn TYPE strmn,
         strur TYPE strur,
         ltrmn TYPE ltrmn,
         ltrur TYPE ltrur,
         ilart TYPE ila,
         otgrp TYPE otgrp,
         oteil TYPE oteil,
         frkls TYPE frkls,
       END OF ty_steel,

       BEGIN OF ty_wood, ""Wood Pole Structure.
         qmart        TYPE qmart, "Paramter field
*         qmnum        TYPE qmnum, "Paramter field
         qmtxt        TYPE qmtxt, "Header
         sttxt        TYPE qmsttxt, "Default
         astxt        TYPE co_asttx, "default
         tplnr        TYPE tplnr, "Header
         equnr        TYPE equnr, "Header
         ingrp        TYPE ingrp, "Header
         gewrk        TYPE gewrk, "Filed Number 21 suspecting
         qmnam        TYPE qmnam, "Header
         erdat        TYPE icrdt1, "Header
         ernam        TYPE icrna, "Header
         qmdat        TYPE qmdat, "Header
         mzeit        TYPE mzeit, "Header
         strmn        TYPE strmn, "Header
         strur        TYPE strur, "Header
         ltrmn        TYPE ltrmn, "Header
         ltrur        TYPE ltrur, "Header
         ilart        TYPE ila,   "default
         rstxt_txline TYPE txline, ""suspecting this field name, Need to check.
         otgrp        TYPE otgrp, "default
         oteil        TYPE oteil, "default
         frkls        TYPE frkls, "default
       END OF ty_wood.

DATA: gt_wooddata           TYPE TABLE OF ty_wood,
      gt_steeldata          TYPE TABLE OF ty_steel,
      gwa_ex_Header         TYPE bapi2080_nothdre,
      gt_items_wood         TYPE TABLE OF bapi2080_notitemi,
      gt_notifcaus          TYPE TABLE OF bapi2080_notcausi,
      gt_notifactv          TYPE TABLE OF bapi2080_notactvi,
      gt_notiftask          TYPE TABLE OF bapi2080_nottaski,
      gwa_save_header       TYPE bapi2080_nothdre,
      gt_msg_log            TYPE TABLE OF bapiret2,

      "Steel Pole data Declerations.
      gwa_ex_Header_steel   TYPE bapi2080_nothdre,
      gt_items_steel        TYPE TABLE OF bapi2080_notitemi,
      gt_notifcaus_steel    TYPE TABLE OF bapi2080_notcausi,
      gt_notifactv_steel    TYPE TABLE OF bapi2080_notactvi,
      gt_notiftask_steel    TYPE TABLE OF bapi2080_nottaski,
      gwa_save_header_steel TYPE bapi2080_nothdre,
      gt_msg_log1           TYPE TABLE OF bapiret2,



      gwa_wooddata          TYPE ty_wood,
      gwa_steeldata         TYPE ty_steel.
