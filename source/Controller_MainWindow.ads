with RASCAL.ToolboxActionButton;  use RASCAL.ToolboxActionButton;
with RASCAL.OS;                   use RASCAL.OS;

package Controller_MainWindow is

   type ButtonClicked_Type is new ATEL_Toolbox_ActionButton_Selected with null record;

   --
   -- The user has clicked on a button.
   --
   procedure Handle (The : in ButtonClicked_Type);

end Controller_MainWindow;
