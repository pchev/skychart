# Microsoft Developer Studio Generated NMAKE File, Based on GETDSS.DSP
!IF "$(CFG)" == ""
CFG=getdss - Win32 Debug
!MESSAGE No configuration specified. Defaulting to getdss - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "getdss - Win32 Release" && "$(CFG)" != "getdss - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "GETDSS.MAK" CFG="getdss - Win32 Debug"
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
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

!IF "$(RECURSE)" == "0" 

ALL : "$(OUTDIR)\GETDSS.dll"

!ELSE 

ALL : "$(OUTDIR)\GETDSS.dll"

!ENDIF 

CLEAN :
	-@erase "$(INTDIR)\Bitinput.obj"
	-@erase "$(INTDIR)\Decode.obj"
	-@erase "$(INTDIR)\Dodecode.obj"
	-@erase "$(INTDIR)\Dss.obj"
	-@erase "$(INTDIR)\Extr_fit.obj"
	-@erase "$(INTDIR)\getdss_dll.obj"
	-@erase "$(INTDIR)\Getpiece.obj"
	-@erase "$(INTDIR)\Hdcmprss.obj"
	-@erase "$(INTDIR)\Hinv.obj"
	-@erase "$(INTDIR)\Makelump.obj"
	-@erase "$(INTDIR)\Platelst.obj"
	-@erase "$(INTDIR)\Qtreedec.obj"
	-@erase "$(INTDIR)\vc50.idb"
	-@erase "$(OUTDIR)\GETDSS.dll"
	-@erase "$(OUTDIR)\GETDSS.exp"
	-@erase "$(OUTDIR)\GETDSS.lib"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /Zp1 /MD /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS"\
 /Fp"$(INTDIR)\GETDSS.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 
CPP_OBJS=.\Release/
CPP_SBRS=.

.c{$(CPP_OBJS)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(CPP_OBJS)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(CPP_OBJS)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.c{$(CPP_SBRS)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(CPP_SBRS)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(CPP_SBRS)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

MTL=midl.exe
MTL_PROJ=/nologo /D "NDEBUG" /mktyplib203 /o NUL /win32 
RSC=rc.exe
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\GETDSS.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib\
 advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib\
 odbccp32.lib /nologo /subsystem:windows /dll /incremental:no\
 /pdb:"$(OUTDIR)\GETDSS.pdb" /machine:I386 /def:".\getdss.def"\
 /out:"$(OUTDIR)\GETDSS.dll" /implib:"$(OUTDIR)\GETDSS.lib" 
DEF_FILE= \
	".\getdss.def"
LINK32_OBJS= \
	"$(INTDIR)\Bitinput.obj" \
	"$(INTDIR)\Decode.obj" \
	"$(INTDIR)\Dodecode.obj" \
	"$(INTDIR)\Dss.obj" \
	"$(INTDIR)\Extr_fit.obj" \
	"$(INTDIR)\getdss_dll.obj" \
	"$(INTDIR)\Getpiece.obj" \
	"$(INTDIR)\Hdcmprss.obj" \
	"$(INTDIR)\Hinv.obj" \
	"$(INTDIR)\Makelump.obj" \
	"$(INTDIR)\Platelst.obj" \
	"$(INTDIR)\Qtreedec.obj"

"$(OUTDIR)\GETDSS.dll" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "getdss - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

!IF "$(RECURSE)" == "0" 

ALL : "$(OUTDIR)\GETDSS.dll"

!ELSE 

ALL : "$(OUTDIR)\GETDSS.dll"

!ENDIF 

CLEAN :
	-@erase "$(INTDIR)\Bitinput.obj"
	-@erase "$(INTDIR)\Decode.obj"
	-@erase "$(INTDIR)\Dodecode.obj"
	-@erase "$(INTDIR)\Dss.obj"
	-@erase "$(INTDIR)\Extr_fit.obj"
	-@erase "$(INTDIR)\getdss_dll.obj"
	-@erase "$(INTDIR)\Getpiece.obj"
	-@erase "$(INTDIR)\Hdcmprss.obj"
	-@erase "$(INTDIR)\Hinv.obj"
	-@erase "$(INTDIR)\Makelump.obj"
	-@erase "$(INTDIR)\Platelst.obj"
	-@erase "$(INTDIR)\Qtreedec.obj"
	-@erase "$(INTDIR)\vc50.idb"
	-@erase "$(INTDIR)\vc50.pdb"
	-@erase "$(OUTDIR)\GETDSS.dll"
	-@erase "$(OUTDIR)\GETDSS.exp"
	-@erase "$(OUTDIR)\GETDSS.ilk"
	-@erase "$(OUTDIR)\GETDSS.lib"
	-@erase "$(OUTDIR)\GETDSS.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /Zp1 /MDd /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D\
 "_WINDOWS" /Fp"$(INTDIR)\GETDSS.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD\
 /c 
CPP_OBJS=.\Debug/
CPP_SBRS=.

.c{$(CPP_OBJS)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(CPP_OBJS)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(CPP_OBJS)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.c{$(CPP_SBRS)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(CPP_SBRS)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(CPP_SBRS)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

MTL=midl.exe
MTL_PROJ=/nologo /D "_DEBUG" /mktyplib203 /o NUL /win32 
RSC=rc.exe
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\GETDSS.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib\
 advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib\
 odbccp32.lib /nologo /subsystem:windows /dll /incremental:yes\
 /pdb:"$(OUTDIR)\GETDSS.pdb" /debug /machine:I386 /def:".\getdss.def"\
 /out:"$(OUTDIR)\GETDSS.dll" /implib:"$(OUTDIR)\GETDSS.lib" /pdbtype:sept 
DEF_FILE= \
	".\getdss.def"
LINK32_OBJS= \
	"$(INTDIR)\Bitinput.obj" \
	"$(INTDIR)\Decode.obj" \
	"$(INTDIR)\Dodecode.obj" \
	"$(INTDIR)\Dss.obj" \
	"$(INTDIR)\Extr_fit.obj" \
	"$(INTDIR)\getdss_dll.obj" \
	"$(INTDIR)\Getpiece.obj" \
	"$(INTDIR)\Hdcmprss.obj" \
	"$(INTDIR)\Hinv.obj" \
	"$(INTDIR)\Makelump.obj" \
	"$(INTDIR)\Platelst.obj" \
	"$(INTDIR)\Qtreedec.obj"

"$(OUTDIR)\GETDSS.dll" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(CFG)" == "getdss - Win32 Release" || "$(CFG)" == "getdss - Win32 Debug"
SOURCE=.\Bitinput.cpp
DEP_CPP_BITIN=\
	".\Bitfile.h"\
	

"$(INTDIR)\Bitinput.obj" : $(SOURCE) $(DEP_CPP_BITIN) "$(INTDIR)"


SOURCE=.\Decode.cpp
DEP_CPP_DECOD=\
	".\Bitfile.h"\
	".\Errcode.h"\
	

"$(INTDIR)\Decode.obj" : $(SOURCE) $(DEP_CPP_DECOD) "$(INTDIR)"


SOURCE=.\Dodecode.cpp
DEP_CPP_DODEC=\
	".\Bitfile.h"\
	".\Errcode.h"\
	

"$(INTDIR)\Dodecode.obj" : $(SOURCE) $(DEP_CPP_DODEC) "$(INTDIR)"


SOURCE=.\Dss.cpp
DEP_CPP_DSS_C=\
	".\Dss.h"\
	

"$(INTDIR)\Dss.obj" : $(SOURCE) $(DEP_CPP_DSS_C) "$(INTDIR)"


SOURCE=.\Extr_fit.cpp
DEP_CPP_EXTR_=\
	".\Dss.h"\
	".\Errcode.h"\
	".\Get_dss.h"\
	".\Platelst.h"\
	

"$(INTDIR)\Extr_fit.obj" : $(SOURCE) $(DEP_CPP_EXTR_) "$(INTDIR)"


SOURCE=.\getdss_dll.cpp
DEP_CPP_GETDS=\
	".\Errcode.h"\
	".\Get_dss.h"\
	".\getdss.h"\
	".\Platelst.h"\
	

"$(INTDIR)\getdss_dll.obj" : $(SOURCE) $(DEP_CPP_GETDS) "$(INTDIR)"


SOURCE=.\Getpiece.cpp
DEP_CPP_GETPI=\
	".\Errcode.h"\
	".\Get_dss.h"\
	".\Platelst.h"\
	

"$(INTDIR)\Getpiece.obj" : $(SOURCE) $(DEP_CPP_GETPI) "$(INTDIR)"


SOURCE=.\Hdcmprss.cpp

"$(INTDIR)\Hdcmprss.obj" : $(SOURCE) "$(INTDIR)"


SOURCE=.\Hinv.cpp
DEP_CPP_HINV_=\
	".\Errcode.h"\
	

"$(INTDIR)\Hinv.obj" : $(SOURCE) $(DEP_CPP_HINV_) "$(INTDIR)"


SOURCE=.\Makelump.cpp

"$(INTDIR)\Makelump.obj" : $(SOURCE) "$(INTDIR)"


SOURCE=.\Platelst.cpp
DEP_CPP_PLATE=\
	".\Dss.h"\
	".\Platelst.h"\
	

"$(INTDIR)\Platelst.obj" : $(SOURCE) $(DEP_CPP_PLATE) "$(INTDIR)"


SOURCE=.\Qtreedec.cpp
DEP_CPP_QTREE=\
	".\Bitfile.h"\
	".\Errcode.h"\
	

"$(INTDIR)\Qtreedec.obj" : $(SOURCE) $(DEP_CPP_QTREE) "$(INTDIR)"



!ENDIF 

