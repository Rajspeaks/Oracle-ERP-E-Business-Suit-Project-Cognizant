select USER_ID from FND_USER where USER_NAME = 'XXCTS_RAJDEEP';
select * from FND_USER where USER_ID = 10147549;


SELECT * FROM FND_RESPONSIBILITY 
WHERE RESPONSIBILITY_KEY = 'XXCTS_RAJDEEP_RESP_MAY22';

--APPLICATION_ID : 201
--RESPONSIBILITY_ID: 68040
--CREATED_BY: 1016345
-- LAST UPDATED BY: 1016345
-- USER_ID: 1017549
-- V_LAST_UPDATE_LOGIN: 7817233;

CREATE OR REPLACE PROCEDURE XXCTS_RAJDEEP_PRJ_RESP_API
 IS
      V_ROWID			 VARCHAR2(200);
      V_RESPONSIBILITY_ID 	NUMBER;
      V_APPLICATION_ID 	NUMBER;
      V_WEB_HOST_NAME 		VARCHAR2(200);
      V_WEB_AGENT_NAME 			VARCHAR2(200);
      V_DATA_GROUP_APPLICATION_ID 	NUMBER;
      V_DATA_GROUP_ID 		NUMBER;
      V_MENU_ID 	NUMBER;
      V_START_DATE 			DATE;
      V_END_DATE 		DATE;
      V_GROUP_APPLICATION_ID 	NUMBER;
      V_REQUEST_GROUP_ID 		NUMBER;
      V_VERSION 		VARCHAR2(200);
      V_RESPONSIBILITY_KEY 		VARCHAR2(200);
      V_RESPONSIBILITY_NAME VARCHAR2(200);
      V_DESCRIPTION 	VARCHAR2(200);
      V_CREATION_DATE 		DATE;
      V_CREATED_BY 			NUMBER;
      V_LAST_UPDATE_DATE 		DATE;
      V_LAST_UPDATED_BY 	NUMBER;
      V_LAST_UPDATE_LOGIN		NUMBER;
  
  BEGIN
                  V_ROWID                       := V_ROWID;
                  SELECT FND_RESPONSIBILITY_S.NEXTVAL INTO V_RESPONSIBILITY_ID
                  FROM DUAL;
                  --V_RESPONSIBILITY_ID           := FND_RESPONSIBILITY_S.NEXTVAL;
                  V_APPLICATION_ID              := 201;        
                  V_WEB_HOST_NAME               := null;
                  V_WEB_AGENT_NAME              := null;
                  V_DATA_GROUP_APPLICATION_ID   := 201;         
                  V_DATA_GROUP_ID               := 0;         
                  V_MENU_ID                     := 68071;      
                  V_START_DATE                  := '27-06-22';
                  V_END_DATE                    := null;
                  V_GROUP_APPLICATION_ID        := 201;
                  V_REQUEST_GROUP_ID            := 112;
                  V_VERSION                     := 4;
                  V_RESPONSIBILITY_KEY          := 'XXCTS_RAJDEEP_MINI';
                  V_RESPONSIBILITY_NAME         := 'RAJDEEP RESP MINI';
                  V_DESCRIPTION                 := 'Responsibility for API';
                  V_CREATION_DATE               := '27-06-22';
                  V_CREATED_BY                  := 1016345;
                  V_LAST_UPDATE_DATE            := '27-06-22';
                  V_LAST_UPDATED_BY             := 1016345;
                  V_LAST_UPDATE_LOGIN           := 7817233;
     --INVOKING THE API
     --FNDGLOBAL.APPSINITIALISE
      FND_RESPONSIBILITY_PKG.INSERT_ROW(
                  X_ROWID	=>	V_ROWID	,
                  X_RESPONSIBILITY_ID => 	V_RESPONSIBILITY_ID	,
                  X_APPLICATION_ID =>V_APPLICATION_ID		,
                  X_WEB_HOST_NAME => V_WEB_HOST_NAME	,
                  X_WEB_AGENT_NAME =>	V_WEB_AGENT_NAME	,
                  X_DATA_GROUP_APPLICATION_ID => V_DATA_GROUP_APPLICATION_ID	,
                  X_DATA_GROUP_ID => V_DATA_GROUP_ID		,
                  X_MENU_ID => V_MENU_ID			,
                  X_START_DATE => V_START_DATE			,
                  X_END_DATE 	=> V_END_DATE		,
                  X_GROUP_APPLICATION_ID => V_GROUP_APPLICATION_ID	,
                  X_REQUEST_GROUP_ID => V_REQUEST_GROUP_ID		,
                  X_VERSION => V_VERSION		,
                  X_RESPONSIBILITY_KEY => V_RESPONSIBILITY_KEY 	,
                  X_RESPONSIBILITY_NAME => V_RESPONSIBILITY_NAME	,
                  X_DESCRIPTION => V_DESCRIPTION		,
                  X_CREATION_DATE => V_CREATION_DATE	,
                  X_CREATED_BY => V_CREATED_BY		,
                  X_LAST_UPDATE_DATE =>  V_LAST_UPDATE_DATE	,
                  X_LAST_UPDATED_BY => V_LAST_UPDATED_BY	,
                  X_LAST_UPDATE_LOGIN	=> V_LAST_UPDATE_LOGIN	);
               commit;
               DBMS_OUTPUT.PUT_LINE('RESPONSIBILITY CREATED');
            end XXCTS_RAJDEEP_PRJ_RESP_API;
            
            
       EXEC XXCTS_RAJDEEP_PRJ_RESP_API;     
            
SELECT *
FROM USER_ERRORS
WHERE NAME =upper('XXCTS_RAJDEEP_PRJ_RESP_API');