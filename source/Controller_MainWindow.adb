with RASCAL.Utility;             use RASCAL.Utility;
with RASCAL.WimpTask;            use RASCAL.WimpTask;

with Main;                       use Main;
with Ada.Exceptions;
with Reporter;

package body Controller_MainWindow is

   --

   package Utility  renames RASCAL.Utility;
   package WimpTask renames RASCAL.WimpTask;
                                   
   --

   procedure Handle (The : in ButtonClicked_Type) is

      Button : Component_ID := Get_Self_Component (Main_Task);
   begin
      Case Button is
      when 2 => Call_Os_CLI ("Cache on");
      when 3 => Call_Os_CLI ("Cache Off");
      when 4 => Call_Os_CLI ("Cache w");
      when 5 => Call_Os_CLI ("Cache iw");
      when others => null;
      end case;
      Main.Set_Status;
   exception
      when Exception_Data : others => Report_Error("BUTTONCLICKED",Ada.Exceptions.Exception_Information (Exception_Data));
   end Handle;

   --

end Controller_MainWindow;
