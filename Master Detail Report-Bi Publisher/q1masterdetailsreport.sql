--Tables: PO_LINES_ALL,PO_HEADERS_ALL, MTL_SYSTEM_ITEMS_B

SELECT PHA.SEGMENT1,
  MSIB.SEGMENT1 AS ITEM_NAME,
  PLA.ITEM_DESCRIPTION,
  PHA.TYPE_LOOKUP_CODE,
  PLA.UNIT_PRICE,
  PLA.QUANTITY
FROM PO_LINES_ALL PLA,
  PO_HEADERS_ALL PHA,
  MTL_SYSTEM_ITEMS_B MSIB
WHERE PLA.PO_HEADER_ID    = PHA.PO_HEADER_ID
AND PLA.ITEM_ID           = MSIB.INVENTORY_ITEM_ID
AND PHA.TYPE_LOOKUP_CODE IN ('RFQ', 'QUOTATION', 'BLANKET', 'STANDARD')
AND MSIB.SEGMENT1 LIKE 'XXCTS_R%';

------------------------------------------------------------------------------

-- Checking the XML data

CREATE OR REPLACE PROCEDURE XXCTS_RAJDEEP_MD_PROJECT
IS
  CURSOR ITEM_CUR
  IS
    SELECT PHA.SEGMENT1,
      MSIB.SEGMENT1 AS ITEM_NAME,
      PLA.ITEM_DESCRIPTION,
      PHA.TYPE_LOOKUP_CODE,
      PLA.UNIT_PRICE,
      PLA.QUANTITY
    FROM PO_LINES_ALL PLA,
      PO_HEADERS_ALL PHA,
      MTL_SYSTEM_ITEMS_B MSIB
    WHERE PLA.PO_HEADER_ID    = PHA.PO_HEADER_ID
    AND PLA.ITEM_ID           = MSIB.INVENTORY_ITEM_ID
    AND PHA.TYPE_LOOKUP_CODE IN ('RFQ', 'QUOTATION', 'BLANKET', 'STANDARD')
    AND MSIB.SEGMENT1 LIKE 'XXCTS_R%';
  ITEM_REC ITEM_CUR%ROWTYPE;
BEGIN
  OPEN ITEM_CUR;
  DBMS_OUTPUT.PUT_LINE('<?xml version="1.0"?>');
  DBMS_OUTPUT.PUT_LINE('<ItemRoot>');
  LOOP
    FETCH ITEM_CUR INTO ITEM_REC;
    EXIT
  WHEN ITEM_CUR%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('<ITEM>');
    DBMS_OUTPUT.PUT_line('<SEGMENT1>' || ITEM_REC.SEGMENT1 || '</SEGMENT1>');
    DBMS_OUTPUT.PUT_LINE('<ITEM_NAME>' || ITEM_REC.ITEM_NAME || '</ITEM_NAME>');
    DBMS_OUTPUT.PUT_LINE('<ITEM_DESCRIPTION>'|| ITEM_REC.ITEM_DESCRIPTION || '</ITEM_DESCRIPTION>');
    DBMS_OUTPUT.PUT_LINE('<TYPE_LOOKUP_CODE>'|| ITEM_REC.TYPE_LOOKUP_CODE || '</TYPE_LOOKUP_CODE>');
    DBMS_OUTPUT.PUT_LINE('<UNIT_PRICE>'|| ITEM_REC.UNIT_PRICE || '</UNIT_PRICE>');
    DBMS_OUTPUT.PUT_LINE('<QUANTITY>'|| ITEM_REC.QUANTITY || '</QUANTITY>');
    DBMS_OUTPUT.PUT_LINE('</ITEM>');
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('</ItemRoot>');
  CLOSE ITEM_CUR;
END;


SELECT * FROM USER_ERRORS WHERE NAME =upper('XXCTS_RAJDEEP_MD_PROJECT');
EXEC XXCTS_RAJDEEP_MD_PROJECT;

-------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE XXCTS_RAJDEEP_MD_PROJECT(
    ERRBUF OUT VARCHAR2,
    RETCODE OUT VARCHAR2)
--ERRBUF : ERROR MESSAGES, RETCODE : STATUS OF PROCEDURE EXECUTION
--THE RETCODE HAS THREE VALUES RETURNED BY THE CONCURRENT MANAGER
--0�SUCCESS
--1�SUCCESS & WARNING
--2�ERROR
IS
  CURSOR ITEM_CUR-- DECLARING THE CURSOR
  IS
  
  -- SQL QUERY
    SELECT PHA.SEGMENT1,
      MSIB.SEGMENT1 AS ITEM_NAME,
      PLA.ITEM_DESCRIPTION,
      PHA.TYPE_LOOKUP_CODE,
      PLA.UNIT_PRICE,
      PLA.QUANTITY
    FROM PO_LINES_ALL PLA,
      PO_HEADERS_ALL PHA,
      MTL_SYSTEM_ITEMS_B MSIB
    WHERE PLA.PO_HEADER_ID    = PHA.PO_HEADER_ID
    AND PLA.ITEM_ID           = MSIB.INVENTORY_ITEM_ID
    AND PHA.TYPE_LOOKUP_CODE IN ('RFQ', 'QUOTATION', 'BLANKET', 'STANDARD')
    AND MSIB.SEGMENT1 LIKE 'XXCTS_R%';
-- Declare a Record
-- Record is a collection of fields
-- Record can be declared on the basis of a table / cursor
-- Declaring a Record based on a Cursor
    
  ITEM_REC ITEM_CUR%ROWTYPE;-- DECLARING RECORD AS ITWM_RECORD
  
-- ITEM_REC is the name of the record
-- ITEM_REC will hold ALL THE INFORMATION

  V_ERROR_CODE  NUMBER;
  V_ERR_MESSAGE VARCHAR2(200);-- --Declaring variables for Error Code and Error Message
  
BEGIN
  OPEN ITEM_CUR;-- It will the execute the query , active set gets created and
-- it will point to the row above the first row
  FND_FILE.PUT_LINE(FND_FILE.OUTPUT,'<?xml version="1.0"?>');
  FND_FILE.PUT_LINE(fnd_file.output,'<ItemRoot>');
  LOOP
  
  -- Fetch fetches one row from the Active Set and stores
-- it into the record

    FETCH ITEM_CUR INTO ITEM_REC;
    
    -- STOP WHEN THE Records present in the Active Set are processed.
    
    EXIT WHEN ITEM_CUR%NOTFOUND;
    FND_FILE.PUT_LINE(FND_FILE.OUTPUT,'<ITEM>');
    FND_FILE.PUT_LINE(FND_FILE.OUTPUT,'<SEGMENT1>' || ITEM_REC.SEGMENT1 || '</SEGMENT1>');
    FND_FILE.PUT_LINE(FND_FILE.OUTPUT,'<ITEM_NAME>' || ITEM_REC.ITEM_NAME || '</ITEM_NAME>');
    FND_FILE.PUT_LINE(FND_FILE.OUTPUT,'<ITEM_DESCRIPTION>'|| ITEM_REC.ITEM_DESCRIPTION || '</ITEM_DESCRIPTION>');
    FND_FILE.PUT_LINE(FND_FILE.OUTPUT,'<TYPE_LOOKUP_CODE>'|| ITEM_REC.TYPE_LOOKUP_CODE || '</TYPE_LOOKUP_CODE>');
    FND_FILE.PUT_LINE(FND_FILE.OUTPUT,'<UNIT_PRICE>'|| ITEM_REC.UNIT_PRICE || '</UNIT_PRICE>');
    FND_FILE.PUT_LINE(FND_FILE.OUTPUT,'<QUANTITY>'|| ITEM_REC.QUANTITY || '</QUANTITY>');
    FND_FILE.PUT_LINE(FND_FILE.OUTPUT,'</ITEM>');
  END LOOP;
  FND_FILE.PUT_LINE(FND_FILE.OUTPUT,'</ItemRoot>');
  CLOSE ITEM_CUR;-- Memory is released.
EXCEPTION
-- Generic Exception Handler
WHEN OTHERS THEN
  V_ERROR_CODE  := SQLCODE;
  -- SQLCode is a function returns the error code
-- SQLERRM is a function which return the message associated with the Error
-- ORA-01476: divisor is equal to zero
-- SQLCode gives 01476
-- SQLERRM gives divisor is equal to zero
-- SUBSTR gives the Substring of length 200 characters
  V_ERR_MESSAGE := SUBSTR(SQLERRM,1,200);
  FND_FILE.PUT_LINE(FND_FILE.LOG, 'Error Code :' || V_ERROR_CODE);
  FND_FILE.PUT_LINE(FND_FILE.LOG,'Error Message :' || V_ERR_MESSAGE);
END;









