&---------------------------------------------------------------------
*& Include          ZVALIDATION
&---------------------------------------------------------------------
&---------------------------------------------------------------------
*& Form application_data
&---------------------------------------------------------------------
*& text
&---------------------------------------------------------------------
*&      --> P_FILE
&---------------------------------------------------------------------
FORM application_data  USING p_p_file.
  DATA:lwa_file TYPE string.

***fetching the Wood data using Open Datasets.
  OPEN DATASET p_p_file FOR INPUT IN TEXT MODE ENCODING DEFAULT.

***Failure case, If Issue with fetching the file.
  IF sy-subrc NE 0 .
    MESSAGE: 'Error while Opening the file' TYPE 'E'.

***Success case, If File fetches from application Server.
  ELSE.
    READ DATASET p_p_file INTO lwa_file.
    IF sy-subrc = 0.
      IF r_wood EQ abap_true.
        APPEND gwa_wooddata TO   gt_wooddata.
      ELSE.
        APPEND gwa_steeldata TO gt_steeldata.
      ENDIF.
    ENDIF.
    CLEAR: lwa_file,gwa_wooddata.
  ENDIF.

  CLOSE DATASET p_p_file.
ENDFORM.
&---------------------------------------------------------------------
*& Form call_bapi
&---------------------------------------------------------------------
*& text
&---------------------------------------------------------------------
*& -->  p1        text
*& <--  p2        text
&---------------------------------------------------------------------
FORM call_bapi .
  DATA:lt_items_wood   TYPE STANDARD TABLE OF bapi2080_notitemi,
       lt_items_steel  TYPE TABLE OF bapi2080_notitemi,
       lwa_notifheader TYPE bapi2080_nothdri,
       lv_notiftype    TYPE bapi2080-notif_type,
       lv_itemkey      TYPE felfd,
       lv_count        TYPE n,
       lv_number       TYPE bapi2080_nothdre-notif_no.

  IF r_wood = abap_true.
    DATA: wa_wooddata  TYPE ty_wood,
          wa_steeldata TYPE ty_steel.


*   Check wood data extistence
    IF gt_wooddata[] IS INITIAL.
      MESSAGE 'No data found for wood' TYPE 'E'.
    ELSE.
      lv_notiftype = 'PM'.
    ENDIF.

*   Process data
    LOOP AT gt_wooddata INTO DATA(lwa_wooddata).
      lwa_notifheader-short_text = 'Pole Inspection Result'.
      "system status for notification not mapped.
      "User status for notficication not mapped.
*      lwa_notifheader-funct_loc = lwa_wooddata-tplnr.
      lwa_notifheader-equipment = lwa_wooddata-equnr.
*      lwa_notifheader-plangroup = lwa_wooddata-ingrp.
*      lwa_notifheader-PM_WKCTR "Check it once again.
      lwa_notifheader-reportedby = sy-uname.
      lwa_notifheader-notif_date = lwa_wooddata-qmdat.
      lwa_notifheader-notiftime = lwa_wooddata-mzeit.
      lwa_notifheader-desstdate = lwa_wooddata-strmn.
      lwa_notifheader-dessttime = lwa_wooddata-strur.
      lwa_notifheader-desenddate = lwa_wooddata-ltrmn.
      lwa_notifheader-desendtm = lwa_wooddata-ltrur.

      lv_itemkey = lv_itemkey + 1.
      APPEND VALUE #( item_key = lv_itemkey dl_codegrp = 'PRGMINSP' d_code = 'WOOD' ) TO lt_items_wood.

      ""Calling the BAPI
      CALL FUNCTION 'BAPI_ALM_NOTIF_CREATE'
        EXPORTING
*         EXTERNAL_NUMBER    =
          notif_type         = lv_notiftype
          notifheader        = lwa_notifheader
*         TASK_DETERMINATION = ' '
*         ORDERID            =
*         IV_DONT_CHK_MANDATORY_PARTNER       =
*         DOCUMENT_ASSIGN_COPY                = ' '
*         MAINTACTYTYPE      =
*         DATE_ADJUSTMENT    = 'O'
        IMPORTING
          notifheader_export = gwa_ex_header
        TABLES
          notitem            = lt_items_wood "gt_items_wood
*         notifcaus          = gt_notifcaus
*         notifactv          = gt_notifactv
*         notiftask          = gt_notiftask
*         gt_notiftask       =
*         notifpartnr        =
*         longtexts          =   ""Should mention long text to this params..based on yesterdays call.
*         key_relationships  =
          return             = gt_msg_log
*         extensionin        =
*         extensionout       =.
        .
************************
******End of the BAPI Calling***********
************************

      READ TABLE gt_msg_log INTO DATA(wa_msg_log) WITH KEY type = 'S'.

      IF sy-subrc = 0.
**Calling Save Notification Bapi.
        lv_number = gwa_ex_header-notif_no.

        CALL FUNCTION 'BAPI_ALM_NOTIF_SAVE'
          EXPORTING
            number      = lv_number
          IMPORTING
            notifheader = gwa_save_header.

        IF gwa_save_header-notif_no IS NOT INITIAL.
          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = 'X'.
        ENDIF.
      ELSE.
        MESSAGE 'Check the Error log' TYPE 'E'.

      ENDIF.

***Clearing the Internal tables and workareas.
      CLEAR: lwa_wooddata,
             lv_number,
              lv_notiftype,
              lwa_notifheader,
              lt_items_wood,
              gwa_ex_header,
              gt_notifcaus,
              gt_notifactv,
              gt_notiftask.
    ENDLOOP.
    CLEAR:lv_itemkey.

  ELSE.

    IF gt_steeldata[] IS INITIAL.
      MESSAGE 'No data found for steel' TYPE 'E'.
    ELSE.
      lv_notiftype = 'PM'.
    ENDIF.

    DATA: lwa_notif_head_steel TYPE bapi2080_nothdri.

    LOOP AT gt_steeldata INTO DATA(lwa_steeldata).

*     ""Field Mappings.
      lwa_notif_head_steel-short_text = 'Pole Inspection Result'.
      "system status for notification not mapped.
      "User status for notficication not mapped.
*      lwa_notifheader-funct_loc = lwa_wooddata-tplnr.
      lwa_notif_head_steel-equipment = lwa_steeldata-equnr.
*      lwa_notifheader-plangroup = lwa_wooddata-ingrp.
*      lwa_notifheader-PM_WKCTR "Check it once again.
      lwa_notif_head_steel-reportedby = sy-uname.
      lwa_notif_head_steel-notif_date = lwa_steeldata-qmdat.
      lwa_notif_head_steel-notiftime = lwa_steeldata-mzeit.
      lwa_notif_head_steel-desstdate = lwa_steeldata-strmn.
      lwa_notif_head_steel-dessttime = lwa_steeldata-strur.
      lwa_notif_head_steel-desenddate = lwa_steeldata-ltrmn.
      lwa_notif_head_steel-desendtm = lwa_steeldata-ltrur.


      lv_itemkey = lv_itemkey + 1.
      APPEND VALUE #( item_key = lv_itemkey dl_codegrp = 'PRGMINSP' d_code = 'WOOD' ) TO lt_items_wood.


      ""Calling the BAPI
      CALL FUNCTION 'BAPI_ALM_NOTIF_CREATE'
        EXPORTING
*         EXTERNAL_NUMBER    =
          notif_type         = lv_notiftype
          notifheader        = lwa_notif_head_steel
*         TASK_DETERMINATION = ' '
*         SENDER             =
*         ORDERID            =
*         IV_DONT_CHK_MANDATORY_PARTNER       =
*         NOTIFCATION_COPY   =
*         DOCUMENT_ASSIGN_COPY                = ' '
*         MAINTACTYTYPE      =
*         DATE_ADJUSTMENT    = 'O'
        IMPORTING
          notifheader_export = gwa_ex_header_steel
*         MAINTACTYTYPE_EXPORT                =
        TABLES
          notitem            = lt_items_steel
*         notifcaus          = gt_notifcaus_steel
*         notifactv          = gt_notifactv_steel
*         notiftask          = gt_notiftask_steel
*         NOTIFPARTNR        =
*         LONGTEXTS          = ""Should mention long text to this params..based on yesterdays call.
*         KEY_RELATIONSHIPS  =
          return             = gt_msg_log1
*         EXTENSIONIN        =
*         EXTENSIONOUT       =
        .
************************
******End of the BAPI Calling***********
************************
      READ TABLE gt_msg_log1 INTO DATA(wa_msg_log2) WITH KEY type = 'S'.

      IF sy-subrc = 0.
**Calling Save Notification Bapi.
        lv_number = gwa_ex_header_steel-notif_no.

        CALL FUNCTION 'BAPI_ALM_NOTIF_SAVE'
          EXPORTING
            number      = lv_number "Pick the notification number from gwa_ex_Header USING READ STATMENT.
          IMPORTING
            notifheader = gwa_save_header_steel.

        IF gwa_save_header_steel-notif_no IS NOT INITIAL.
          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = 'X'.

        ENDIF.
      ELSE.
        MESSAGE 'Check the Error log' TYPE 'E'.

      ENDIF.

***Clearing the Internal tables and workareas.
      CLEAR: lwa_steeldata,
             lv_number,
              lv_notiftype,
              lt_items_steel,
              gwa_ex_header_steel,
              gt_notifcaus_steel,
              gt_notifactv_steel,
              gt_notiftask_steel.

    ENDLOOP.
    clear: lv_itemkey.
  ENDIF.
ENDFORM.