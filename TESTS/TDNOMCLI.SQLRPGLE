**free
Ctl-Opt  NoMain;

/Copy RPGUNIT/RPGUNIT1,TESTCASE
/Copy H1FRPTECHS/QCOPSRC,S_ERRORDS

Dcl-S wCommande    Char(512);
Dcl-S wRc          Int(10);

Dcl-Pr ExecCmd     Int(10) ExtProc('system');
  cmdString        Pointer Value Options(*String);
End-Pr;

Dcl-Pr tearDown
End-Pr;

Dcl-Pr RmvLibLe;
End-Pr;

//---------------------------------------------------------------
// Procédure de nettoyage en fin de test (appelée en sortie)
Dcl-Proc tearDown  Export;
  Dcl-Pi *N;
  End-Pi;

  RmvLibLe();

  // Suppression de la journalisation
  SuppJourn();

  // Suppression de la table
  exec sql
  drop table t_nomCliTU/client;

  // Suppression de la collection t_nomCliTU qui contient la table
  Exec Sql
  drop collection t_nomCliTU;

  Assert(SqlCode = 0
        :'Erreur lors de la suppression de la collection t_nomCliTU, '
        + 'SqlCode = ' + %Char(SqlCode));
End-Proc;

//------------------------------------------------------------------
// Suppression de la journalisation
//------------------------------------------------------------------
Dcl-Proc SuppJourn;

  // Arrêter la journalisation de fichier physique
  wCommande = 'EndJrnPf File(*All) Jrn(t_nomCliTU/QSQJRN)';
  wRc = ExecCmd(%trim(wCommande));

  Assert (wRc = 0
         :'Une erreur est survenue lors du EndJrnPf, rc = ' + %Char(wRc)
         );

  // Supprimer le journal
  wCommande = 'DltJrn Jrn(t_nomCliTU/QSQJRN)';
  wRc = ExecCmd(%trim(wCommande));

  Assert(wRc = 0
        :'Une erreur est survenue lors du DltJrn, rc = ' + %Char(wRc)
        );

  // Supprimer le récepteur du journal
  wCommande = 'DltJrnRcv JrnRcv(t_nomCliTU/QSQJR*) DltOpt(*IgnInqMsg)';
  wRc = ExecCmd(%trim(wCommande));

  Assert(wRc = 0
        :'Une erreur est survenue lors du DltJrnRcv, rc = ' + %Char(wRc)
        );
End-Proc;

//------------------------------------------------------------------
// Procédure debut: rmvlible_Moc
//------------------------------------------------------------------
Dcl-Proc RmvLibLe;

  wCommande = 'RmvLibLe Lib(t_nomCliTU)';

  // Execution commande
  wRc = execCmd(%Trim(wCommande));

  Assert(wRc = 0
        :'Une erreur est survenue lors du RmvLibLe');

End-Proc; 
