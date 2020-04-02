**free                                                                                              
                                                                                                    
ctl-opt nomain;                                                                                     
                                                                                                    
/copy RPGUNIT/RPGUNIT1,TESTCASE                                                                     
                                                                                                    
Dcl-S wCommande         Char(512);                                                                  
                                                                                                    
Dcl-Pr AddLibLe;                                                                                    
End-Pr;                                                                                             
                                                                                                    
Dcl-Pr ExecCmd          Int(10) ExtProc('system');                                                  
  cmdString             Pointer Value Options(*String);                                             
End-Pr;                                                                                             
                                                                                                    
Dcl-Pr setUp                                                                                        
End-Pr;                                                                                             
                                                                                                    
//---------------------------------------------------------------                                   
// Procédure de mise en place des tests, appelée en entrée                                          
//  elle permet d'initialiser l'environnement (bdd) pour avoir                                      
//  des jeux de test toujours identiques et propres                                                 
                                                                                                    
Dcl-Proc setUp  Export;                                                                             
  Dcl-Pi *N;                                                                                        
  End-Pi;                                                                                           
                                                                                                    
  exec sql                                                                                          
  create collection T_NOMCLITU;                                                                     
                                                                                                    
  Assert(SqlCode = 0                                                                                
        :'Erreur création collection T_NOMCLITU : SqlCode = ' + %Char(SqlCode));                    
                                                                                                    
  // Création table T_NOMCLITU/client                                                               
  Exec Sql                                                                                          
  create table t_nomCliTU/client                                                                    
  (numClient decimal(5, 0),                                                                         
   nomClient char(50),                                                                              
   prenomClient char(50));                                                                          
                                                                                                    
  Assert(SqlCode = 0                                                                                
        :'Erreur creation table t_nomCliTU/client ' + %Char(SqlCode));                              
                                                                                                    
   AddLibLe();                                                                                      
                                                                                                    
end-proc;                                                                                           
                                                                                                    
                                                                                                    
//------------------------------------------------------------------                                
// Procédure début: AddLibLe                                                                        
//------------------------------------------------------------------                                
Dcl-Proc AddLibLe;                                                                                  
  Dcl-S rc              Int(10);                                                                    
                                                                                                    
  wCommande = 'AddLibLe Lib(t_nomCliTU)';                                                           
                                                                                                    
  // Execution commande                                                                             
  rc = ExecCmd(%Trim(wCommande));                                                                   
                                                                                                    
  Assert(rc = 0                                                                                     
        :'Une erreur est survenue lors du AddLibLe de t_nomCliTU');                                 
End-Proc;                                                                                            
