**free                                                                                              
                                                                                                    
ctl-opt nomain;                                                                                     
                                                                                                    
/Copy H1FRPTECHS/QCOPSRC,S_ERRORDS                                                                  
/Copy RPGUNIT/RPGUNIT1,TESTCASE                                                                     
                                                                                                    
/copy MILFORT/QCOPSRC,nomCliDs                                                                      
                                                                                                    
dcl-pr nomcli extpgm('NOMCLI');                                                                     
  nomCliDs likeDs(nomCliDs_template);                                                               
end-pr;                                                                                             
                                                                                                    
dcl-ds nomCliDs  likeDs(nomCliDs_template);                                                         
                                                                                                    
// Définition des constantes                                                                        
dcl-c APPLICATION                   Const('ADHTU');                                                 
dcl-c nomTest                       Const('T_NOMCLITU');                                            
                                                                                                    
// Définition des varibles                                                                          
dcl-s rc                            Int(10);                                                        
                                                                                                    
// Prototypes                                                                                       
dcl-pr execCmd                      Int(10) ExtProc('system');                                      
  CmdString                         Pointer Value Options(*String);                                 
end-pr;                                                                                             
                                                                                                    
dcl-pr chargeDB2;                                                                                   
  nomTest                           Char(10) Const;                                                 
  testCase                          Char(10) Const;                                                 
end-pr;                                                                                             
                                                                                                    
dcl-Pr renameTableAller;                                                                            
end-Pr;                                                                                             
dcl-Pr renameTableRetour;                                                                           
end-Pr;                                                                                             
                                                                                                    
//dcl-pr test_01_parametreNumeroClientInvalide;                                                     
//end-pr;                                                                                           
//                                                                                                  
//dcl-pr test_02_tableClientInexistante;                                                            
//end-pr;                                                                                           
//                                                                                                  
//dcl-pr test_03_client4EnDouble;                                                                   
//end-pr;                                                                                           
                                                                                                    
//dcl-pr test_04_client5NonTrouve;                                                                  
//end-pr;                                                                                           
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
//-------------------------------------------------------------                                     
// Cas de test 1 :cas non passant-parametre invalide                                                
dcl-proc test_01_parametreNumeroClientInvalide Export;                                              
                                                                                                    
  dcl-pi *N;                                                                                        
  end-pi;                                                                                           
                                                                                                    
  clear nomCliDs;                                                                                   
  nomCliDS.inDs.numClient = 0;                                                                      
                                                                                                    
  nomCli(nomCliDs);                                                                                 
                                                                                                    
  // résultat attendu : erreur = parametre invalide                                                 
  // test ok : erreur détectée par nomcli     -> return code = 1                                    
  // test ko : erreur non détectée par nomcli -> return code = 0                                    
  assert(nomCliDs.ouDs.returnCode = 1                                                               
        :'Erreur : parametre invalide non détecté par NOMCLI');                                     
                                                                                                    
end-proc;                                                                                           
                                                                                                    
//-------------------------------------------------------------                                     
// Cas de test 2 :cas non passant - la table client n'existe pas                                    
dcl-proc test_02_tableClientInexistante Export;                                                     
                                                                                                    
  dcl-pi *N;                                                                                        
  end-pi;                                                                                           
                                                                                                    
  clear nomCliDs;                                                                                   
  nomCliDS.inDs.numClient = 1;                                                                      
                                                                                                    
  renameTableAller();                                                                               
                                                                                                    
  nomCli(nomCliDs);                                                                                 
                                                                                                    
  // résultat attendu : erreur = table absente                                                      
  // test ok : erreur détectée par nomcli     -> return code = 1                                    
  // test ko : erreur non détectée par nomcli -> return code = 0                                    
  Assert(nomCliDs.ouDs.returnCode = 1                                                               
        :'Erreur : table absente non détectée par NOMCLI');                                         
                                                                                                    
  renameTableRetour();                                                                              
                                                                                                    
                                                                                                    
end-proc;                                                                                           
                                                                                                    
//-------------------------------------------------------------                                     
// Cas de test 3 : cas non passant - client numero 4 en double                                      
dcl-proc test_03_client4EnDouble Export;                                                            
                                                                                                    
  dcl-pi *N;                                                                                        
  end-pi;                                                                                           
                                                                                                    
  chargeDB2(APPLICATION: 'nomcli03');                                                               
                                                                                                    
  clear nomCliDs;                                                                                   
  nomCliDS.inDs.numClient = 4;                                                                      
                                                                                                    
  nomCli(nomCliDs);                                                                                 
                                                                                                    
  // résultat attendu : erreur = erreur sql 2 lignes pour num client                                
  // test ok : erreur détectée par nomcli     -> return code = 1                                    
  // test ko : erreur non détectée par nomcli -> return code = 0                                    
  assert(nomCliDs.ouDs.returnCode = 1                                                               
        :'Erreur : client 4 en double non détecté par NOMCLI');                                     
                                                                                                    
end-proc;                                                                                           
                                                                                                    
//-------------------------------------------------------------                                     
// Cas de test 4 : cas passant - client numero 5 non trouvé                                         
dcl-proc test_04_client5NonTrouve Export;                                                           
                                                                                                    
  dcl-pi *N;                                                                                        
  end-pi;                                                                                           
                                                                                                    
  chargeDB2(APPLICATION: 'nomcli04');                                                               
                                                                                                    
  clear nomCliDs;                                                                                   
  nomCliDS.inDs.numClient = 5;                                                                      
                                                                                                    
  nomCli(nomCliDs);                                                                                 
                                                                                                    
  // résultat attendu : erreur = erreur sql 2 lignes pour num client                                
  // test ok : pas erreur détectée par nomcli -> return code = 0                                    
  // test ok : pas erreur détectée par nomcli -> client non trouvé                                  
  // test ok : pas erreur détectée par nomcli -> nom client à blanc                                 
                                                                                                    
  Assert(nomCliDs.ouDs.returnCode = 0                                                               
        :'Erreur NOMCLI : erreur détéctée');                                                        
                                                                                                    
    Assert(nomCliDs.ouDs.clientTrouve = *off                                                        
          :'Erreur NOMCLI : client trouvé');                                                        
                                                                                                    
      Assert(nomCliDs.ouDs.nomClient = *blanks                                                      
            :'Erreur NOMCLI : nom client renseigné');                                               
                                                                                                    
end-proc;                                                                                           
                                                                                                    
//-------------------------------------------------------------                                     
// Cas de test 5 : cas passant - client numero 2 trouvé                                             
                                                                                                    
dcl-proc test_05_client2Trouve Export;                                                              
                                                                                                    
  dcl-pi *N;                                                                                        
  end-pi;                                                                                           
                                                                                                    
  chargeDB2(APPLICATION: 'nomcli05');                                                               
                                                                                                    
  clear nomCliDs;                                                                                   
  nomCliDS.inDs.numClient = 2;                                                                      
                                                                                                    
  nomCli(nomCliDs);                                                                                 
                                                                                                    
  // résultat attendu : pas erreur                                                                  
  // test ok : pas erreur détectée par nomcli -> return code = 0                                    
  // test ok : pas erreur détectée par nomcli -> client 2 trouvé                                    
  // test ok : pas erreur détectée par nomcli -> nom client = JEAN                                  
  // test ok : pas erreur détectée par nomcli -> prenom client = Ana                                
                                                                                                    
  Assert(nomCliDs.ouDs.returnCode = 0                                                               
        :'Erreur NOMCLI : erreur détectée returnCode <> 0');                                        
    Assert(nomCliDs.ouDs.clientTrouve = *on                                                         
          :'Erreur NOMCLI : client 2 pas trouve');                                                  
      Assert(nomCliDs.ouDs.nomClient = 'JEAN'                                                       
           :'Erreur NOMCLI : nom client 2 pas JEAN');                                               
        Assert(nomCliDs.ouDs.prenomClient = 'Ana'                                                   
              :'Erreur NOMCLI : prenom client 2 pas Ana');                                          
                                                                                                    
                                                                                                    
end-proc;                                                                                           
                                                                                                    
//---------------------------------------------------------------                                   
// Procédure de mise en place des tests appelée en entrée                                           
                                                                                                    
dcl-Proc chargeDB2;                                                                                 
                                                                                                    
  dcl-Pi *N;                                                                                        
    APPLICATION                     Char(10) Const;                                                 
    testCase                        Char(10) Const;                                                 
  end-Pi;                                                                                           
                                                                                                    
  dcl-S  wCommand                   Char(512);                                                      
  dcl-S  rc                         Int(10);                                                        
                                                                                                    
  rc = 0;                                                                                           
  wCommand = 'RUNSQLSTM '                                                                           
           + 'SRCSTMF'                                                                              
           + '('''                                                                                  
           + '/Application/Adhesion/TU/chargeDB2/t_nomcli/' + %trim(testCase)                       
           + '.sql'                                                                                 
           + ''') '                                                                                 
           + 'COMMIT(*NC) '                                                                         
           + 'MARGINS(112)';                                                                        
                                                                                                    
  rc = execCmd(wCommand);                                                                           
                                                                                                    
  Assert(rc = 0                                                                                     
        :'Erreur survenue lors du chargement données en BDD pour ' + %Trim(testCase));              
                                                                                                    
end-Proc;                                                                                           
                                                                                                    
//------------------------------------------------------------------                                
// Procédure début: AddLibLe                                                                        
//------------------------------------------------------------------                                
dcl-proc renameTableAller;                                                                          
                                                                                                    
dcl-S wCommand                   Char(512);                                                         
dcl-S rc              Int(10);                                                                      
                                                                                                    
  wCommand = 'RNMOBJ OBJ(T_NOMCLITU/CLIENT) OBJTYPE(*FILE) NEWOBJ(CLIENTS)';                        
                                                                                                    
  // Execution commande                                                                             
  rc = ExecCmd(%Trim(wCommand));                                                                    
                                                                                                    
  Assert(rc = 0                                                                                     
        :'Une erreur est survenue lors du rename table client en clients');                         
end-Proc;                                                                                           
                                                                                                    
dcl-proc renameTableRetour;                                                                         
                                                                                                    
dcl-S wCommand                   Char(512);                                                         
dcl-s rc              Int(10);                                                                      
                                                                                                    
  clear wCommand;                                                                                   
  wCommand = 'RNMOBJ OBJ(T_NOMCLITU/CLIENTS) OBJTYPE(*FILE) NEWOBJ(CLIENT)';                        
                                                                                                    
  // Execution commande                                                                             
  rc = ExecCmd(%Trim(wCommand));                                                                    
                                                                                                    
  Assert(rc = 0                                                                                     
        :'Une erreur est survenue lors du rename table clients en client');                         
End-Proc;                                                                                            
