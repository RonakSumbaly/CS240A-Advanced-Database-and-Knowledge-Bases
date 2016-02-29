------ PARTITION ------
-- This script partitions the initial database table (dataset) into two
-- subsets: testset and trainset. It also verticalizes the data in the
-- sense that it creates a record in testset or trainset for each column
-- run using (-td~ -vf) 

---- INITIALIZATION ----

CONNECT TO SAMPLE~

-- drop the tables we're about to create, in case they already exist
DROP TABLE TEST_DATASET~
DROP TABLE TRAIN_DATASET~

-- create the tables

CREATE TABLE TEST_DATASET("PID" INTEGER, "COLUMNNO" INTEGER, "ATT" VARCHAR(10),"DECISION" VARCHAR(10), "WEIGHT" INTEGER)~ -- CREATE TEST DATASET TABLE
CREATE TABLE TRAIN_DATASET("PID" INTEGER, "COLUMNNO" INTEGER, "ATT" VARCHAR(10),"DECISION" VARCHAR(10), "WEIGHT" INTEGER)~ -- CREATE TRAIN DATASET TABLE

-- transfer content to trainset and testset

BEGIN ATOMIC
	FOR temp AS SELECT * FROM DATASET ORDER BY PID DO  --LOOP THROUGH ENTIRE DATASET
	IF rand() > 0.75 THEN   -- SELECT RECORDS ON RANDOM AND ADD TO TEST IF < 75 %
		INSERT INTO TEST_DATASET VALUES 
		(temp.PID, 3, temp.sex, temp.survived, 1),
		(temp.PID, 1, temp.class, temp.survived, 1),
		(temp.PID, 2, temp.type, temp.survived, 1);
		
	ELSE    -- SELECT RECORDS ON RANDOM AND ADD TO TRAIN
		INSERT INTO TRAIN_DATASET VALUES 
		(temp.PID, 3, temp.sex, temp.survived, 1),
		(temp.PID, 1, temp.class, temp.survived, 1),
		(temp.PID, 2, temp.type, temp.survived, 1);
	END IF;
	END FOR;
END~

CONNECT RESET ~
TERMINATE~