SELECT * FROM AP_SUPPLIERS WHERE LAST_UPDATED_BY = 1017549;

SELECT * FROM AP_SUPPLIERS ;--WHERE LAST_UPDATE_DATE = '30-06-22';

SELECT * FROM FND_USER WHERE USER_NAME ='XXCTS_RAJDEEP';

--USER_ID: 1017549

select sysdate from dual;


SELECT * FROM AP_SUPPLIERS_INT;
SELECT * FROM AP_SUPPLIER_SITES_INT;

--DELETE FROM AP_SUPPLIERS_INT;
--DELETE FROM AP_SUPPLIER_SITES_INT;

--STAGING TABLE 1
CREATE TABLE MP_RAJDEEP_PRJ_INT1
  (
    VENDOR_INTERFACE_ID NUMBER,
    VENDOR_NAME         VARCHAR2(100),
    SEGMENT1            VARCHAR2(100),
    SUMMARY_FLAG        VARCHAR2(100),
    ENABLED_FLAG        VARCHAR2(100)
  );
  
  --DROP TABLE MP_RAJDEEP_PRJ_INT1;
  
INSERT
INTO MP_RAJDEEP_PRJ_INT1
  (
    VENDOR_INTERFACE_ID,
    VENDOR_NAME,
    SEGMENT1,
    SUMMARY_FLAG,
    ENABLED_FLAG
  )
  VALUES
  (
    54,
    'RAJDEEP DAS',
    'RD123',
    'Y',
    'Y'
  );
INSERT
INTO MP_RAJDEEP_PRJ_INT1
  (
    VENDOR_INTERFACE_ID,
    VENDOR_NAME,
    SEGMENT1,
    SUMMARY_FLAG,
    ENABLED_FLAG
  )
  VALUES
  (
    55,
    'HARRY POTTER',
    'RD456',
    'Y',
    'Y'
  );
INSERT
INTO MP_RAJDEEP_PRJ_INT1
  (
    VENDOR_INTERFACE_ID,
    VENDOR_NAME,
    SEGMENT1,
    SUMMARY_FLAG,
    ENABLED_FLAG
  )
  VALUES
  (
    56,
    'JOSHEF MICHEAL',
    'RD789',
    'Y',
    'Y'
  );
INSERT
INTO MP_RAJDEEP_PRJ_INT1
  (
    VENDOR_INTERFACE_ID,
    VENDOR_NAME,
    SEGMENT1,
    SUMMARY_FLAG,
    ENABLED_FLAG
  )
  VALUES
  (
    57,
    'BRIAN HUMPRIES',
    'RD111',
    'Y',
    'Y'
  );

SELECT * FROM MP_RAJDEEP_PRJ_INT1;

ALTER TABLE MP_RAJDEEP_PRJ_INT1 ADD PROCESS_FLAG VARCHAR2(1);


--STAGING TABLE 2
CREATE TABLE MP_RAJDEEP_PRJ_INT2
  (
    VENDOR_INTERFACE_ID NUMBER,
    VENDOR_SITE_CODE    NUMBER,
    VENDOR_ID           NUMBER,
    ZIP                 VARCHAR2(60),
    STATE               VARCHAR2(100),
    VENDOR_SITE_INTERFACE_ID NUMBER
  );
  
  --DROP TABLE MP_RAJDEEP_PRJ_INT2;
  
INSERT
INTO MP_RAJDEEP_PRJ_INT2
  (
    VENDOR_INTERFACE_ID,
    VENDOR_SITE_CODE,
    VENDOR_ID,
    ZIP,
    STATE,
    VENDOR_SITE_INTERFACE_ID
  )
  VALUES
  (
    100,
    500,
    700,
    'IN',
    'WEST BENGAL',
    3001
  );
INSERT
INTO MP_RAJDEEP_PRJ_INT2
  (
    VENDOR_INTERFACE_ID,
    VENDOR_SITE_CODE,
    VENDOR_ID,
    ZIP,
    STATE,
    VENDOR_SITE_INTERFACE_ID
  )
  VALUES
  (
    101,
    501,
    701,
    'IN',
    'BIHAR',
    3002
  );
INSERT
INTO MP_RAJDEEP_PRJ_INT2
  (
    VENDOR_INTERFACE_ID,
    VENDOR_SITE_CODE,
    VENDOR_ID,
    ZIP,
    STATE,
    VENDOR_SITE_INTERFACE_ID
  )
  VALUES
  (
    102,
    502,
    702,
    'IN',
    'JHARKHAND',
    3003
  );
INSERT
INTO MP_RAJDEEP_PRJ_INT2
  (
    VENDOR_INTERFACE_ID,
    VENDOR_SITE_CODE,
    VENDOR_ID,
    ZIP,
    STATE,
    VENDOR_SITE_INTERFACE_ID
  )
  VALUES
  (
    103,
    503,
    703,
    'IN',
    'UP',
    3004
  );
--DROP TABLE MP_RAJDEEP_PRJ_INT2;
SELECT *
FROM MP_RAJDEEP_PRJ_INT2;
ALTER TABLE MP_RAJDEEP_PRJ_INT2 ADD PROCESS_FLAG VARCHAR2(1);

-------------------------------------------------------------------------------
------------------------------------------------------------------------------

CREATE OR REPLACE PACKAGE XXCTS_RAJDEEP_PRJ_INTERFACE
IS
  PROCEDURE VALIDATION_RAJDEEP_V1;
  PROCEDURE VALIDATION_RAJDEEP_V2;
  PROCEDURE INSERT_RAJDEEP_PROC;
END XXCTS_RAJDEEP_PRJ_INTERFACE;
--------------------------------------------------------------------
  
  
  
 CREATE OR REPLACE PACKAGE BODY XXCTS_RAJDEEP_PRJ_INTERFACE
IS
  PROCEDURE VALIDATION_RAJDEEP_V1
  IS
    CURSOR ITEM_CUR
    IS
      SELECT * FROM MP_RAJDEEP_PRJ_INT1;
    V_NAME_COUNT NUMBER;
    V_SEG_COUNT  NUMBER;
    V_TYPE PO_LOOKUP_CODES_OLD.LOOKUP_CODE%TYPE;
    V_ERROR_FLAG BOOLEAN:=FALSE;
    -----------------------------------------------------------------------
  BEGIN
    FOR ITEM_REC IN ITEM_CUR
    LOOP
      BEGIN
        SELECT COUNT(VENDOR_NAME)
        INTO V_NAME_COUNT
        FROM AP_SUPPLIERS
        WHERE VENDOR_NAME=ITEM_REC.VENDOR_NAME;
        IF V_NAME_COUNT  >0 THEN
          FND_FILE.PUT_LINE(FND_FILE.LOG,'DUPLICATE NAME EXISTS');
          DBMS_OUTPUT.PUT_LINE('DUPLICATE NAME EXISTS');
          V_ERROR_FLAG:=TRUE;
        END IF;
      END;
      -----------------------------------------------------------------------------
      BEGIN
        SELECT COUNT(SEGMENT1)
        INTO V_SEG_COUNT
        FROM AP_SUPPLIERS
        WHERE SEGMENT1=ITEM_REC.SEGMENT1;
        IF V_SEG_COUNT>0 THEN
          FND_FILE.PUT_LINE(FND_FILE.LOG,'DUPLICATE SEGMENT EXISTS');
          DBMS_OUTPUT.PUT_LINE('DUPLICATE SEGMENT HAS BEEN FOUND');
          V_ERROR_FLAG:=TRUE;
        END IF;
      END;
      --------------------------------------------------------------------------------
      IF V_ERROR_FLAG=TRUE THEN
        UPDATE MP_RAJDEEP_PRJ_INT1
        SET PROCESS_FLAG='N'
        WHERE SEGMENT1  = ITEM_REC.SEGMENT1;
      ELSE
        UPDATE MP_RAJDEEP_PRJ_INT1
        SET PROCESS_FLAG='Y'
        WHERE SEGMENT1  = ITEM_REC.SEGMENT1;
      END IF;
    END LOOP;
  END VALIDATION_RAJDEEP_V1;
  PROCEDURE VALIDATION_RAJDEEP_V2
  IS
    CURSOR VEN_CUR2
    IS
      SELECT * FROM MP_RAJDEEP_PRJ_INT2;
    V_CODE FND_TERRITORIES_TL.TERRITORY_CODE%TYPE;
    V_ERROR_FLAG BOOLEAN:=FALSE;
  BEGIN
    FOR VEN_REC2 IN VEN_CUR2
    LOOP
      BEGIN
        SELECT TERRITORY_CODE
        INTO V_CODE
        FROM FND_TERRITORIES_TL
        WHERE TERRITORY_CODE=VEN_REC2.ZIP
        AND LANGUAGE        ='US';
        IF V_CODE          IS NULL THEN
          FND_FILE.PUT_LINE(FND_FILE.LOG,'ZIP CODE NOT FOUND');
          V_ERROR_FLAG:=TRUE;
        END IF;
      END;
      IF V_ERROR_FLAG=TRUE THEN
        UPDATE MP_RAJDEEP_PRJ_INT2
        SET PROCESS_FLAG          ='N'
        WHERE VENDOR_INTERFACE_ID = VEN_REC2.VENDOR_INTERFACE_ID;
      ELSE
        UPDATE MP_RAJDEEP_PRJ_INT2
        SET PROCESS_FLAG          ='Y'
        WHERE VENDOR_INTERFACE_ID = VEN_REC2.VENDOR_INTERFACE_ID;
      END IF;
    END LOOP;
  END VALIDATION_RAJDEEP_V2;
  PROCEDURE INSERT_RAJDEEP_PROC
  IS
    CURSOR INSERT_CUR1
    IS
      SELECT * FROM MP_RAJDEEP_PRJ_INT1;
    CURSOR INSERT_CUR2
    IS
      SELECT * FROM MP_RAJDEEP_PRJ_INT2;
  BEGIN
    DELETE FROM AP_SUPPLIERS_INT;
    DELETE FROM AP_SUPPLIER_SITES_INT;
    COMMIT;
    FOR INSERT_REC1 IN INSERT_CUR1
    LOOP
      INSERT
      INTO AP_SUPPLIERS_INT
        (
          VENDOR_INTERFACE_ID,
          VENDOR_NAME,
          SUMMARY_FLAG,
          ENABLED_FLAG,
          SEGMENT1
        )
        VALUES
        (
          INSERT_REC1.VENDOR_INTERFACE_ID,
          INSERT_REC1.VENDOR_NAME,
          INSERT_REC1.SUMMARY_FLAG,
          INSERT_REC1.ENABLED_FLAG,
          INSERT_REC1.SEGMENT1
        );
      COMMIT;
    END LOOP;
    FOR INSERT_REC2 IN INSERT_CUR2
    LOOP
      INSERT
      INTO AP_SUPPLIER_SITES_INT
        (
          VENDOR_INTERFACE_ID,
          VENDOR_SITE_CODE,
          VENDOR_ID,
          ZIP,
          STATE,
          VENDOR_SITE_INTERFACE_ID
        )
        VALUES
        (
          INSERT_REC2.VENDOR_INTERFACE_ID,
          INSERT_REC2.VENDOR_SITE_CODE,
          INSERT_REC2.VENDOR_ID,
          INSERT_REC2.ZIP,
          INSERT_REC2.STATE,
          INSERT_REC2.VENDOR_SITE_INTERFACE_ID
        );
      COMMIT;
    END LOOP;
  END INSERT_RAJDEEP_PROC;
END XXCTS_RAJDEEP_PRJ_INTERFACE;



------------------------------------------------------------------------------


exec XXCTS_RAJDEEP_PRJ_INTERFACE.VALIDATION_RAJDEEP_V1;
exec XXCTS_RAJDEEP_PRJ_INTERFACE.VALIDATION_RAJDEEP_V2;
exec XXCTS_RAJDEEP_PRJ_INTERFACE.INSERT_RAJDEEP_PROC;

-----------------------------------------------------------------------------

SELECT *
FROM MP_RAJDEEP_PRJ_INT2;

SELECT * FROM MP_RAJDEEP_PRJ_INT1;