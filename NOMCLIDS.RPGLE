      // exemple de DS contenant :
       //   - une ds avec parametres entrée
       //   - une ds avec parametres sortie

       // parametres en entrée (input)
       dcl-ds inDs_template qualified;
         numClient int(5);
       end-ds;

       // parametres en sortie (output)
       dcl-ds ouDS_template qualified;
         nomClient char(50);
         returnCode int(10);
       end-ds;

       // la ds passée en parametre
       dcl-ds nomcliDs_template qualified;
         //entrée
         inDs likeDs(inDs_template);
         //sortie
         ouDs likeDs(ouDs_template);
       end-ds;

 