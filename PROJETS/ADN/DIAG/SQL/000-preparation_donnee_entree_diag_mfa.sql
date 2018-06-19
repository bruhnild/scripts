/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 16/03/2017
Objet : Préparation des tables en entrée
Modification : 
Nom : Faucher Marine - Date : 25/04/2017 - Motif/nature : Remise à plat du script après mise en base (localhost) de toutes les données ADN
Nom : Faucher Marine - Date : 31/07/2017 - Motif/nature : Mise en pratique des scripts (export/import tables sources/resultats)
-------------------------------------------------------------------------------------
*/



--********************* Structuration des tables ***************************


/*
--- Schema : chantier
--- Table : ft_chambre

---- Caractériser le type de conduite 

ALTER TABLE chantier.ft_arciti
ADD type_reseau varchar  --- ajout champ "type_reseau"
;

UPDATE chantier.ft_arciti
SET type_reseau = 'autre'  
WHERE compositio is null 
;

UPDATE chantier.ft_arciti 
SET type_reseau = 'distribution'  
WHERE compositio like '%Ø2%' --- diamètre ~ 20 
OR compositio like '%Ø3%' --- diamètre ~ 30 
OR compositio like '%Ø4%' --- diamètre ~ 40 
OR compositio like '%Ø5%' --- diamètre ~ 50 
AND mode_pose = '7' --- selection des conduites uniquement
;

UPDATE chantier.ft_arciti
SET type_reseau = 'transport'  
WHERE compositio like '%Ø6%' --- diamètre ~ 60 
OR compositio like '%Ø7%' --- diamètre ~ 70 
OR compositio like '%Ø8%' --- diamètre ~ 80 
OR compositio like '%Ø9%' --- diamètre ~ 90 
OR compositio like '%Ø1%' --- diamètre ~ 100 
AND mode_pose = '7' --- selection des conduites uniquement 
;

UPDATE chantier.ft_arciti
SET type_reseau = 'autre' --- Reste des cables de réseaux non caractérisés
WHERE type_reseau is null 
;

--- Schema : chantier
--- Table : ft_chambre

ALTER TABLE chantier.ft_chambre
ADD ref_chambr_valid varchar  --- ajout champ "ref_chambr_valid"
;

--- Caractériser les chambres d'après leur références en percutable/non percutable 

UPDATE chantier.ft_chambre
SET ref_chambr_valid = 'non percutable' 
WHERE 

NON PERCUTABLES


ref_chambr = 'L0T'
OR ref_chambr ='LOT' 
OR ref_chambr ='L0P'
OR ref_chambr ='LOP' 
OR ref_chambr ='LIP'   
OR ref_chambr = 'L1T'
OR ref_chambr ='L1C'
OR ref_chambr = 'L1P'
OR ref_chambr ='L2P'  
OR ref_chambr = 'L2C'
OR ref_chambr = 'L2P'
OR ref_chambr = 'L2T'
OR ref_chambr = 'A1'
OR ref_chambr = 'A/2'
OR ref_chambr = 'A/1'
OR ref_chambr ='1/2' 
OR ref_chambr ='1/2 A1' 
OR ref_chambr ='1/2A1'
OR ref_chambr ='A1a'
OR ref_chambr ='1/2a1'  
OR ref_chambr = 'A2'
OR ref_chambr ='A2a' 
OR ref_chambr ='A2A'
OR ref_chambr = 'A3'
OR ref_chambr ='A3a' 
OR ref_chambr ='A3A' 
OR ref_chambr = 'REG' 
OR ref_chambr ='regard' 
OR ref_chambr ='REGARD' 
OR ref_chambr = '30X'
OR ref_chambr = 'TB'
OR ref_chambr = 'TBT'
OR ref_chambr ='K1C'   
OR ref_chambr ='INT'    
OR ref_chambr ='30X'  
OR ref_chambr ='B3' 
OR ref_chambr ='SPE'  
OR ref_chambr ='SPÉ'  
OR ref_chambr ='01A'  
OR ref_chambr ='INC'  
OR ref_chambr ='CH' 
OR ref_chambr ='CH privee'  
OR ref_chambr ='ch privee'  
OR ref_chambr ='S'    
OR ref_chambr ='SNCF' 
OR ref_chambr ='PAX111' 
OR ref_chambr ='R'  
OR ref_chambr ='60x60'  
OR ref_chambr ='90x90'
OR ref_chambr ='60x50'  
OR ref_chambr ='CANIVEAU TRN' 
OR ref_chambr ='CANIVEAU' 
OR ref_chambr ='RDD7' 
OR ref_chambr ='TA' 
OR ref_chambr ='PAX'  
OR ref_chambr ='DR5'  
OR ref_chambr ='Sp' 
OR ref_chambr ='TB.'  
OR ref_chambr ='LGD'    
OR ref_chambr ='TM' 
OR ref_chambr ='DIAS'   
OR ref_chambr ='TA' 
OR ref_chambr ='RG' 
OR ref_chambr ='TB' 
OR ref_chambr ='CH' 
OR ref_chambr ='DR3' 
OR ref_chambr = 'TAB'  
;

PERCUTABLES

ref_chambr ='OHN' 
OR ref_chambr ='A4' 
OR ref_chambr ='A4a'  
OR ref_chambr ='A4A'
OR ref_chambr ='A10' 
OR ref_chambr ='POA10'  
OR ref_chambr ='B1' 
OR ref_chambr ='B2' 
OR ref_chambr ='C1' 
OR ref_chambr ='C2' 
OR ref_chambr ='C3'
OR ref_chambr ='D1' 
OR ref_chambr ='1/2 D1A'  
OR ref_chambr ='D1A' 
OR ref_chambr ='D1a'
OR ref_chambr ='D1as'
OR ref_chambr ='D1AS'
OR ref_chambr ='D1b'  
OR ref_chambr ='D1B'    
OR ref_chambr ='D2' 
OR ref_chambr ='D2s' 
OR ref_chambr ='D2SP' 
OR ref_chambr ='D3' 
OR ref_chambr ='D4' 
OR ref_chambr ='D4T'
OR ref_chambr ='D4C'  
OR ref_chambr ='D12'  
OR ref_chambr ='E1' 
OR ref_chambr ='E2' 
OR ref_chambr ='E3' 
OR ref_chambr = 'E4'
OR ref_chambr ='K2C'  
OR ref_chambr ='K3C'
OR ref_chambr ='L3T' 
OR ref_chambr ='L3P'  
OR ref_chambr ='L3C'
OR ref_chambr ='L4T'  
OR ref_chambr ='L4C'    
OR ref_chambr ='1/2L4T'   
OR ref_chambr ='L4T' 
OR ref_chambr ='1/2L4P'
OR ref_chambr ='L4P' 
OR ref_chambr ='L5T'
OR ref_chambr ='L5P'
OR ref_chambr ='L6T'  
OR ref_chambr ='L6P'  
OR ref_chambr ='M1'   
OR ref_chambr ='M1C' 
OR ref_chambr ='M2'  
OR ref_chambr ='M3'
OR ref_chambr ='M3C'  
OR ref_chambr ='P1' 
OR ref_chambr ='P1C'  
OR ref_chambr ='P2' 
OR ref_chambr ='P2C'  
OR ref_chambr ='P3' 
OR ref_chambr ='P4' 
OR ref_chambr ='P5' 
OR ref_chambr ='P6' 


*/
