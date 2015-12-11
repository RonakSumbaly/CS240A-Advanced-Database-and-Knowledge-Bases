------ LOAD ------
-- This script loads the data from an external file and stores it into a table called "DATASET."
-- This script should be run after first.
-- run using (-tvf) 

---- INITIALIZATION ----

CONNECT TO SAMPLE;

CREATE TABLE DATASET("PID" INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1, NO CACHE ) , "CLASS" VARCHAR (10), "TYPE" VARCHAR (10),"SEX" VARCHAR (10),"SURVIVED" VARCHAR (10)); 

---- LOAD FROM DATA FILE OF DATASET ----

LOAD FROM 'C:/Users/Ronak Sumbaly/Downloads/Dataset.data' OF del INSERT INTO DATASET(Class, Type, Sex, Survived);

CONNECT RESET ;
TERMINATE;