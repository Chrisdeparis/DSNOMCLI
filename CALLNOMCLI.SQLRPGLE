**free                                                                                              
ctl-opt option(*srcstmt) dftactgrp(*No);                                                            
                                                                                                    
// ds spécifique au prog callNomCli                                                                 
/copy MILFORT/qcopsrc,cnomclids                                                                     
                                                                                                    
// ds commune au prog callNOMCLI et au progr nomCli                                                 
/copy MILFORT/qcopsrc,nomCliDs                                                                      
                                                                                                    
dcl-pi *n;                                                                                          
  // paremeter list = un seul élément une ds = un seul parm = num cli                               
  cnomclids likeDs(cnomcliDS_template);                                                             
  //numCliChar char(5);                                                                             
end-pi;                                                                                             
                                                                                                    
dcl-pr nomcli extpgm('NOMCLI');                                                                     
  toto likeDs(nomCliDs_template);                                                                   
end-pr;                                                                                             
                                                                                                    
dcl-ds nomCliDs  likeDs(nomCliDs_template);                                                         
                                                                                                    
// variables de travail                                                                             
dcl-s w_message char(50);                                                                           
dcl-s w_numCliNum packed(5:0);                                                                      
dcl-s w_returnCodeNum int(10);                                                                      
                                                                                                    
dcl-s errCheckParm ind;                                                                             
                                                                                                    
exsr checkParm;                                                                                     
if not errCheckParm;                                                                                
                                                                                                    
  w_message =   'num client char : '                                                                
              + %trim(cnomCliDS.numCliChar)                                                         
              + ')';                                                                                
  dsply (%trim(w_message));                                                                         
                                                                                                    
  // nomCliDS.inDs.numClient = cnomcliDS.numCliInt;                                                 
  nomCliDS.inDs.numClient = %dec(cnomCliDS.numCliChar:5:0);                                         
                                                                                                    
  nomCli(nomCliDs);                                                                                 
                                                                                                    
  if nomCliDs.ouDS.returnCode = 0; // tout va bien                                                  
    clear w_message;                                                                                
    w_message =   ' in.n°Client '                                                                   
                + %char(nomCliDS.inDS.numClient)                                                    
                + ' ou.nom '                                                                        
                + %trim(nomCliDs.ouDS.nomClient)                                                    
                + ' ou.rc '                                                                         
                + %char(nomCliDs.ouDS.returnCode)                                                   
               + ')';                                                                               
                                                                                                    
    dsply (%trim(w_message));                                                                       
                                                                                                    
  else;  // erreur rencontree pendant execution nomcli                                              
    clear w_message;                                                                                
    w_message =   ' erreur nomcli '                                                                 
                + ' pour client numero : '                                                          
                + %char(nomCliDS.inDS.numClient);                                                   
    dsply (%trim(w_message));                                                                       
  endif;                                                                                            
                                                                                                    
else;                                                                                               
    // erreur parametres                                                                            
endif;                                                                                              
                                                                                                    
*inlr = *on;                                                                                        
                                                                                                    
//---------------------------------------------------------------------                             
                                                                                                    
begsr checkParm;                                                                                    
                                                                                                    
  errCheckParm = *off;                                                                              
  clear w_numCliNum;                                                                                
                                                                                                    
  // controle valeur de numClient                                                                   
  if cnomCliDS.numCliChar <> *blanks;                                                               
                                                                                                    
    monitor;                                                                                        
                                                                                                    
      w_numCliNum = %dec(cnomCliDS.numCliChar:5:0);                                                 
                                                                                                    
    on-error *all; // numClient non numérique                                                       
      dsply ('parametre non numérique');                                                            
      errCheckParm = *on;                                                                           
    endmon;                                                                                         
                                                                                                    
  else; // numClient = blanc                                                                        
    dsply ('parametre à blanc');                                                                    
    errCheckParm = *on;                                                                             
  endif;                                                                                            
                                                                                                    
endsr;                                                                                               