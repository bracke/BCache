with Controller_Quit;                  use Controller_Quit;
with Controller_MainWindow;            use Controller_MainWindow;
with Controller_Internet;              use Controller_Internet;
with Controller_Bugz;                  use Controller_Bugz;
with Controller_Help;                  use Controller_Help;
with Controller_Dummy;                 use Controller_Dummy;
with Controller_Error;                 use Controller_Error;
with Reporter;
with Ada.Exceptions;

with RASCAL.ToolboxDisplayField;       use RASCAL.ToolboxDisplayField;
with RASCAL.FileExternal;              use RASCAL.FileExternal;
with RASCAL.SystemInfo;                use RASCAL.SystemInfo;
with RASCAL.Toolbox;                   use RASCAL.Toolbox;
with RASCAL.ToolboxWindow;             use RASCAL.ToolboxWindow;
with RASCAL.Utility;                   use RASCAL.Utility;
with RASCAL.Error;                     use RASCAL.Error;
with RASCAL.MessageTrans;              use RASCAL.MessageTrans;
with RASCAL.Mode;                      use RASCAL.Mode;
with RASCAL.ToolboxProgInfo;

package body Main is

   --

   package ToolboxDisplayField renames RASCAL.ToolboxDisplayField;
   package FileExternal        renames RASCAL.FileExternal;       
   package SystemInfo          renames RASCAL.SystemInfo;         
   package Toolbox             renames RASCAL.Toolbox;            
   package ToolboxWindow       renames RASCAL.ToolboxWindow;      
   package Utility             renames RASCAL.Utility;            
   package Error               renames RASCAL.Error;              
   package MessageTrans        renames RASCAL.MessageTrans;       
   package Mode                renames RASCAL.Mode;               
   package ToolboxProgInfo     renames RASCAL.ToolboxProgInfo;

   --

   procedure Set_Status is
   begin
      ToolboxDisplayField.Set_Value (main_objectid,1,
                                     MessageTrans.Lookup(Cache_Status_Type'Image(SystemInfo.Get_CacheStatus),
                                     Get_Message_Block(Main_Task)));
   exception
      when others => ToolboxDisplayField.Set_Value (main_objectid,1,"");
   end Set_Status;

   --

   procedure Open_Window is
   begin
      if x_pos > Mode.Get_X_Resolution (OSUnits) or
         y_pos > Mode.Get_Y_Resolution (OSUnits) or
                                       x_pos < 0 or y_pos < 0 then

         Toolbox.Show_Object (main_objectid,0,0,Centre);
      else
         Toolbox.Show_Object_At (main_objectid,x_pos,y_pos,0,0);
      end if;
      
   end Open_Window;

   --

   procedure Report_Error (Token : in String;
                           Info  : in String) is

      E        : Error_Pointer          := Get_Error (Main_Task);
      M        : Error_Message_Pointer  := new Error_Message_Type;
      Result   : Error_Return_Type;
   begin
      M.all.Token(1..Token'Length) := Token;
      M.all.Param1(1..Info'Length) := Info;
      M.all.Category := Warning;
      M.all.Flags    := Error_Flag_OK;
      Result         := Error.Show_Message (E,M);
   end Report_Error;

   --

   procedure Main is

      ProgInfo_Window : Object_ID;
      Misc            : Messages_Handle_Type;
      Dummy           : Unbounded_String;
   begin
      -- Messages
      Add_Listener (Main_Task,new MEL_Message_Bugz_Query);
      Add_Listener (Main_Task,new MEL_Message_Quit);

      -- Toolbox Events
      Add_Listener (Main_Task,new TEL_Quit_Quit);
      Add_Listener (Main_Task,new TEL_ViewManual_Type);
      Add_Listener (Main_Task,new TEL_ViewSection_Type);
      Add_Listener (Main_Task,new TEL_ViewIHelp_Type);
      Add_Listener (Main_Task,new TEL_ViewHomePage_Type);
      Add_Listener (Main_Task,new TEL_SendEmail_Type);
      Add_Listener (Main_Task,new TEL_CreateReport_Type);      
      Add_Listener (Main_Task,new TEL_Toolbox_Error);
      Add_Listener (Main_Task,new ButtonClicked_Type);
      Add_Listener (Main_Task,new TEL_Dummy);

      -- Start task
      Set_Resources_Path(Main_Task,"<BCacheRes$Dir>");
      Initialise(Main_Task);

      main_objectid   := Toolbox.Create_Object ("Window",From_Template);
      ProgInfo_Window := Toolbox.Create_Object("ProgInfo",From_Template);
      ToolboxProgInfo.Set_Version(ProgInfo_Window,MessageTrans.Lookup("VERS",Get_Message_Block(Main_Task)));

      if FileExternal.Exists(Choices_Read & ".Misc") then
         Misc := MessageTrans.Open_File(Choices_Read & ".Misc");
         begin
            Read_Integer ("XPOS",x_pos,Misc);
            Read_Integer ("YPOS",y_pos,Misc);
         exception
            when others => null;            
         end;
      end if;

      begin
         ToolboxDisplayField.Set_Value (main_objectid,1,
                                        MessageTrans.Lookup(Cache_Status_Type'Image(SystemInfo.Get_CacheStatus),
                                        Get_Message_Block(Main_Task)));
      exception
         when others => ToolboxDisplayField.Set_Value (main_objectid,1,"");
      end;

      Set_Status;
      if SystemInfo.Get_CPU /= StrongARM then
         ToolboxWindow.Gadget_Fade (main_objectid,4);
         ToolboxWindow.Gadget_Fade (main_objectid,5);
      end if;
      Open_Window;

      Poll(Main_Task);

   exception
      when e: others => Report_Error("UNTRAPPED",Ada.Exceptions.Exception_Information (e));
   end Main;

   --

end Main;

