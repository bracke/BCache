with Ada.Strings.Unbounded;      use Ada.Strings.Unbounded;

with RASCAL.WimpTask;            use RASCAL.WimpTask;
with RASCAL.OS;                  use RASCAL.OS;
with RASCAL.Variable;            use RASCAL.Variable;

package Main is

   -- Constants
   app_name       : constant String := "BCache";
   Choices_Write  : constant String := "<Choices$Write>." & app_name;
   Choices_Read   : constant String := "Choices:" & app_name;

   --
   Main_Task      : ToolBox_Task_Class;
   main_objectid  : Object_ID             := -1;
   x_pos          : Integer               := -1;
   y_pos          : Integer               := -1;

   --
   procedure Set_Status;

   --

   procedure Report_Error (Token : in String;
                           Info  : in String);

   --

   procedure Main;

   --

 end Main;


