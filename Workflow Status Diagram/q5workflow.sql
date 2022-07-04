--CREATING THE PROCEDURE WITHIN THE PACKAGE
CREATE OR REPLACE PACKAGE XXCTS_RAJDEEP_PRJ_WF-- PACKAGE NAME IS XXCTS_WORKFLOW_PACK_WEEKEND
IS
	PROCEDURE CHECK_DAY_TIME (ITEMTYPE IN VARCHAR2,--PROCEDURE NAME IS CHECK_DAY_TIME
	itemkey in varchar2,
	actid in number,
	FUNCMODE IN VARCHAR2, 
	RESULT IN OUT VARCHAR2); 
END XXCTS_RAJDEEP_PRJ_WF; 
/

-----------------------------------------------------------------------------
-------------------------------------------------------------------------------

CREATE OR REPLACE PACKAGE BODY XXCTS_RAJDEEP_PRJ_WF
IS
  PROCEDURE CHECK_DAY_TIME(
      ITEMTYPE IN VARCHAR2,
      itemkey  IN VARCHAR2,
      actid    IN NUMBER,
      FUNCMODE IN VARCHAR2,
      RESULT   IN OUT VARCHAR2)
  IS
 ----------------------------------------------------------- 
 -- declaring variables
    V_DAY1  VARCHAR2(3);
    V_DAY2  VARCHAR2(3);
    V_TIME1 NUMBER;
    V_TIME2 NUMBER;
  ---------------------------------------------------------  
  BEGIN
    SELECT TO_CHAR(SYSDATE,'DY') INTO V_DAY1 FROM DUAL;-- QUERY TO DAY
    SELECT TO_CHAR(SYSDATE,'HH24') INTO V_TIME1 FROM DUAL; --QUERY TO TIME
    
    WF_ENGINE.SETITEMATTRTEXT  --SETITEMATTRTEXT FOR V_DAY1
    (ITEMTYPE=>ITEMTYPE, 
    ITEMKEY =>ITEMKEY, 
    ANAME=>'DAY_OF_THE_WEEK',
    AVALUE=>V_DAY1 );
    
    V_DAY2 := WF_ENGINE.GETITEMATTRTEXT --GETITEMATTRTEXT FOR V_DAY2
    ( ITEMTYPE => ITEMTYPE, 
    ITEMKEY => ITEMKEY,
    ANAME => 'DAY_OF_THE_WEEK');
    
    ------------------------------------------------------------------
    
    WF_ENGINE.SETITEMATTRTEXT --SETITEMATTRTEXT FOR V_TIME1
    (ITEMTYPE=>ITEMTYPE, 
    ITEMKEY =>ITEMKEY, 
    ANAME=>'TIME_OF_THE_DAY',
    AVALUE=>V_TIME1 );
    
    V_TIME2 := WF_ENGINE.GETITEMATTRTEXT --SETITEMATTRTEXT FOR V_TIME2
    ( ITEMTYPE => ITEMTYPE, 
    ITEMKEY => ITEMKEY,
    ANAME => 'TIME_OF_THE_DAY');
    
    --------------------------------------------------------------------
    
    IF V_DAY2 IN ('SAT','SUN') AND V_TIME2 BETWEEN 9 AND 18 THEN-- CONDITION
      RESULT := 'COMPLETE:Y';
    ELSE
      RESULT := 'COMPLETE:N';
    END IF;
 -------------------------------------------------------------------------   
  END CHECK_DAY_TIME;
END XXCTS_RAJDEEP_PRJ_WF;
/