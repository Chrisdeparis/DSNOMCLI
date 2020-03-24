**free                                                                                              
ctl-opt option(*srcstmt) dftactgrp(*No);                                                            
                                                                                                    
// ds commune au prog callNOMCLI et au progr nomcli                                                 
/copy MILFORT/qcopsrc,nomCliDs                                                                      
                                                                                                    
dcl-pi *n;                                                                                          
  // paremeter list = un seul élément                                                               
  nomCliDs likeDs(nomCliDs_template);                                                               
end-pi;                                                                                             
                                                                                                    
// variables de travail                                                                             
dcl-s w_message    char(50);                                                                        
dcl-s w_numCli     int(5);                                                                          
dcl-s w_nomCli    char(50);                                                                         
dcl-s errCheckParm ind;                                                                             
                                                                                                    
monitor;                                                                                            
                                                                                                    
  clear w_numCli;                                                                                   
  clear nomCliDS.ouDs;                                                                              
  //nomCliDS.ouDs.returnCode = 0;                                                                   
  //nomCliDS.ouDs.nomClient = 0;                                                                    
                                                                                                    
  //exsr checkParm;                                                                                 
  //if not errCheckParm;                                                                            
                                                                                                    
  w_message =   'nomclids :  ( num client : '                                                       
              + %char(nomCliDS.inDs.numClient)                                                      
              + ')';                                                                                
                                                                                                    
  dsply (%trim(w_message));                                                                         
                                                                                                    
  w_numCli = %dec(nomCliDS.inDs.numClient:5:0);                                                     
                                                                                                    
  exsr recherCheNomClient;                                                                          
                                                                                                    
  //nomCliDS.ouDs.nomClient = 'Durand';                                                             
                                                                                                    
  //else;                                                                                           
// erreur parametres                                                                                
//endif;                                                                                            
                                                                                                    
on-error *all;                                                                                      
                                                                                                    
endmon;                                                                                             
//endif;                                                                                            
                                                                                                    
*inlr = *on;                                                                                        
                                                                                                    
//-----------------------------------------------------------------------------                     
begsr recherCheNomClient;                                                                           
                                                                                                    
  clear w_nomCli;                                                                                   
                                                                                                    
  exec sql                                                                                          
  select NOMCLIENT                                                                                  
  into :w_nomCli                                                                                    
  from MILFORT.CLIENT                                                                               
  where NUMCLIENT=:w_numCli;                                                                        
                                                                                                    
  if sqlcode = 0;                                                                                   
    nomCliDS.OuDs.nomClient = w_nomCli;                                                             
  else;                                                                                             
    dsply (' erreur sql '                                                                           
         + %char(sqlcode)                                                                           
         + ' client n° '                                                                            
         + %char(w_numCli)                                                                          
         + ' non trouvé '                                                                           
         );                                                                                         
  endif;                                                                                            
                                                                                                    
endsr;                                                                                              
                                                                                                    
//---------------------------------------------------------------------                             
                                                                                                    
//  begsr checkParm;                                                                                
//                                                                                                  
//errCheckParm = *off;                                                                              
//                                                                                                  
//// controle valeur de numClient                                                                   
//if parmDs.numClient <> *blanks;                                                                   
//  monitor;                                                                                        
//    w_numCliChar = 0;                                                                             
//    w_numCliChar = %dec(parmDs.numClient:5:0);                                                    
//    // controle valeur de nomClient                                                               
//    if parmDs.nomClient <> *blanks;                                                               
//      monitor;                                                                                    
//        w_nomCliChar = 0;                                                                         
//        w_nomCliChar = %dec(parmDs3.nomClient:50:0);                                              
//      on-error *all; // nomClient non numérique                                                   
//        errCheckParm = *on;                                                                       
//      endmon;                                                                                     
//    else; // nomClient = blanc                                                                    
//      errCheckParm = *on;                                                                         
//    endif;                                                                                        
//  on-error *all; // numClient non numérique                                                       
//    errCheckParm = *on;                                                                           
//  endmon;                                                                                         
//else; // numClient = blanc                                                                        
//  errCheckParm = *on;                                                                             
//endif;                                                                                            
                                                                                                    
//if errCheckParm;                                                                                  
//  dsply ('le parametre numClient ou le parametre nomClient est invalide');                        
//endif;                                                                                            
                                                                                                    
//endsr;                                                                                             