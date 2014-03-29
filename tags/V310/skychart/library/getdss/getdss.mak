# Microsoft Developer Studio Generated NMAKE File, Based on getdss.dsp
!IF "$(CFG)" == ""
CFG=getdss - Win32 Release
!MESSAGE No configuration specified. Defaulting to getdss - Win32 Release.
!ENDIF 

!IF "$(CFG)" != "getdss - Win32 Release" && "$(CFG)" != "getdss - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "getdss.mak" CFG="getdss - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "getdss - Win32 Release" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE "getdss - Win32 Debug" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "getdss - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release

ALL : "..\Release\getdss.dll"


CLEAN :
	-@erase "$(INTDIR)\bitinput.obj"
	-@erase "$(INTDIR)\decode.obj"
	-@erase "$(INTDIR)\dodecode.obj"
	-@erase "$(INTDIR)\dss.obj"
	-@erase "$(INTDIR)\extr_fit.obj"
	-@erase "$(INTDIR)\getdss_dll.obj"
	-@erase "$(INTDIR)\getpiece.obj"
	-@erase "$(INTDIR)\hdcmprss.obj"
	-@erase "$(INTDIR)\hinv.obj"
	-@erase "$(INTDIR)\platelst.obj"
	-@erase "$(INTDIR)\qtreedec.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\getdss.exp"
	-@erase "$(OUTDIR)\getdss.lib"
	-@erase "..\Release\getdss.dll"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /Zp1 /MD /W3 /GX /O2 /D "NDEBUG" /D "WIN32" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "GETDSS_EXPORTS" /D "FIX_3DIGIT_EXPS" /Fp"$(INTDIR)\getdss.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

.c{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.c{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

MTL=midl.exe
MTL_PROJ=/nologo /D "NDEBUG" /mktyplib203 /win32 
RSC=rc.exe
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\getdss.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /dll /incremental:no /pdb:"$(OUTDIR)\getdss.pdb" /machine:I386 /def:"..\..\get_dss\getdss.def" /out:"../Release/getdss.dll" /implib:"$(OUTDIR)\getdss.lib" 
DEF_FILE= \
	"..\..\get_dss\getdss.def"
LINK32_OBJS= \
	"$(INTDIR)\bitinput.obj" \
	"$(INTDIR)\decode.obj" \
	"$(INTDIR)\dodecode.obj" \
	"$(INTDIR)\dss.obj" \
	"$(INTDIR)\getdss_dll.obj" \
	"$(INTDIR)\getpiece.obj" \
	"$(INTDIR)\hdcmprss.obj" \
	"$(INTDIR)\hinv.obj" \
	"$(INTDIR)\platelst.obj" \
	"$(INTDIR)\qtreedec.obj" \
	"$(INTDIR)\extr_fit.obj"

"..\Release\getdss.dll" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "getdss - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug

ALL : "..\Debug\getdss.dll"


CLEAN :
	-@erase "$(INTDIR)\bitinput.obj"
	-@erase "$(INTDIR)\decode.obj"
	-@erase "$(INTDIR)\dodecode.obj"
	-@erase "$(INTDIR)\dss.obj"
	-@erase "$(INTDIR)\extr_fit.obj"
	-@erase "$(INTDIR)\getdss_dll.obj"
	-@erase "$(INTDIR)\getpiece.obj"
	-@erase "$(INTDIR)\hdcmprss.obj"
	-@erase "$(INTDIR)\hinv.obj"
	-@erase "$(INTDIR)\platelst.obj"
	-@erase "$(INTDIR)\qtreedec.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\getdss.exp"
	-@erase "$(OUTDIR)\getdss.lib"
	-@erase "$(OUTDIR)\getdss.pdb"
	-@erase "..\Debug\getdss.dll"
	-@erase "..\Debug\getdss.ilk"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /Zp1 /ML /W3 /Gm /GX /ZI /Od /D "_DEBUG" /D "WIN32" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "GETDSS_EXPORTS" /D "FIX_3DIGIT_EXPS" /Fp"$(INTDIR)\getdss.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

.c{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.c{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

MTL=midl.exe
MTL_PROJ=/nologo /D "_DEBUG" /mktyplib203 /win32 
RSC=rc.exe
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\getdss.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /dll /incremental:yes /pdb:"$(OUTDIR)\getdss.pdb" /debug /machine:I386 /def:"..\..\get_dss\getdss.def" /out:"../Debug/getdss.dll" /implib:"$(OUTDIR)\getdss.lib" /pdbtype:sept 
DEF_FILE= \
	"..\..\get_dss\getdss.def"
LINK32_OBJS= \
	"$(INTDIR)\bitinput.obj" \
	"$(INTDIR)\decode.obj" \
	"$(INTDIR)\dodecode.obj" \
	"$(INTDIR)\dss.obj" \
	"$(INTDIR)\getdss_dll.obj" \
	"$(INTDIR)\getpiece.obj" \
	"$(INTDIR)\hdcmprss.obj" \
	"$(INTDIR)\hinv.obj" \
	"$(INTDIR)\platelst.obj" \
	"$(INTDIR)\qtreedec.obj" \
	"$(INTDIR)\extr_fit.obj"

"..\Debug\getdss.dll" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("getdss.dep")
!INCLUDE "getdss.dep"
!ELSE 
!MESSAGE Warning: cannot find "getdss.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "getdss - Win32 Release" || "$(CFG)" == "getdss - Win32 Debug"
SOURCE=..\..\get_dss\bitinput.cpp

"$(INTDIR)\bitinput.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\get_dss\decode.cpp

"$(INTDIR)\decode.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\get_dss\dodecode.cpp

"$(INTDIR)\dodecode.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\get_dss\dss.cpp

"$(INTDIR)\dss.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\get_dss\extr_fit.cpp

"$(INTDIR)\extr_fit.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\get_dss\getdss_dll.cpp

"$(INTDIR)\getdss_dll.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\get_dss\getpiece.cpp

"$(INTDIR)\getpiece.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\get_dss\hdcmprss.cpp

"$(INTDIR)\hdcmprss.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\get_dss\hinv.cpp

"$(INTDIR)\hinv.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\get_dss\platelst.cpp

"$(INTDIR)\platelst.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\get_dss\qtreedec.cpp

"$(INTDIR)\qtreedec.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)



!ENDIF 

