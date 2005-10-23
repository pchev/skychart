unit execshieldfix;

// --------------------------------------------------------------------------
//
// Fix for missing execution flag in Kylix generated ELF files,
// causing those executables to crash on Linux Kernels that
// have exec-shield enabled.
//
// This fix works by reading the ELF tables mapped to memory
// after program load, and finding loadable segments that are
// marked for read and write only. It then fiddles out the
// aligned memory addresses these segments are loaded to, and
// fixes the memory protection flag to include execution access
// with a call to Libc mprotect.
//
// To use this fix, include this unit as VERY FIRST unit in
// your PROJECTS use clause. This is important, this unit needs
// to be executed before the Classes.pas initialization.
//
// This fix is written by Simon Kissel in August 2004.
// It is licensed under the BSD license. Feel free to use it
// in your projects.
//
// Project homepage is at http://crosskylix.untergrund.net
// You may reach my by mail at scamp@untergrund.net
//
// --------------------------------------------------------------------------

{.$DEFINE debug_execshieldfix}
// Remove the '.' to get debug info on your console.

{$WARN SYMBOL_PLATFORM OFF}
interface

implementation

uses
{$IFDEF debug_execshieldfix}
  SysUtils,
{$ENDIF}
  Libc;

type
  Elf32_Addr = Cardinal;
  Elf32_Half = Word;
  Elf32_Off = Cardinal;
  Elf32_Sword = Integer;
  Elf32_Word = Cardinal;

  TElfHeader = packed record
    e_ident: packed array[0..15] of char;
    e_type: Elf32_Half;
    e_machine: Elf32_Half;
    e_version: Elf32_Word;
    e_entry: Elf32_Addr;
    e_phoff: Elf32_Off;
    e_shoff: Elf32_Off;
    e_flags: Elf32_Word;
    e_ehsize: Elf32_Half;
    e_phentsize: Elf32_Half;
    e_phnum: Elf32_Half;
    e_shentsize: Elf32_Half;
    e_shnum: Elf32_Half;
    e_shstrndx: Elf32_Half;
  end;

  PElfHeader = ^TElfHeader;

  TProgramHeader = packed record
    p_type: Elf32_Word;
    p_offset: Elf32_Off;
    p_vaddr: Elf32_Addr;
    p_paddr: Elf32_Addr;
    p_filesz: Elf32_Word;
    p_memsz: Elf32_Word;
    p_flags: Elf32_Word;
    p_align: Elf32_Word;
  end;

  PProgramHeader = ^TProgramHeader;

procedure fixsegments;
var ElfHeader:PElfHeader;
    i:integer;
    ProgramHeaders: array of PProgramHeader;
    ProgramHeaderOffset:integer;
    LoadAddress:Cardinal;
    AlignedAddress:Cardinal;
    AlignedEndAddress:Cardinal;
    AlignedSize:integer;
    Alignment:Cardinal;
begin
  ElfHeader:=ExeBaseAddress;

{$IFDEF debug_execshieldfix}
  if (ElfHeader.e_ident[1]<>'E') or (ElfHeader.e_ident[2]<>'L') or (ElfHeader.e_ident[3]<>'F') then
  begin
    writeln('Error: This is not a valid linux ELF binary.');
    halt(3);
  end;

  write('Checking ELF Header... ');

  if ElfHeader.e_phentsize=sizeof(TProgramHeader) then
  begin
    writeln('OK');
  end
  else
  begin
    writeln;
    writeln('Error: Unsupported Program Header size.');
    writeln('If this file really is a Kylix compiled ELF executable, please report');
    writeln('back to the author.');
    halt(4);
  end;

  writeln('Reading Program Headers...');
{$ENDIF}

  setlength(ProgramHeaders,ElfHeader.e_phnum);
  ProgramHeaderOffset:=ElfHeader.e_phoff;


  for i:=0 to ElfHeader.e_phnum-1 do
  begin
    ProgramHeaders[i]:=pointer(ProgramHeaderOffset+integer(ExeBaseAddress)+i*sizeof(TProgramHeader));
  end;

{$IFDEF debug_execshieldfix}
  writeln('Checking Program Header table...');
{$ENDIF}

  for i:=0 to ElfHeader.e_phnum-1 do
  begin
    if ProgramHeaders[i].p_type=1 then
    begin
{$IFDEF debug_execshieldfix}
      write('  Loadable segment at '+inttohex(ProgramHeaders[i].p_vaddr,8)+'/'+inttohex(ProgramHeaders[i].p_paddr,8)+', Size '+inttohex(ProgramHeaders[i].p_memsz,8)+', Flags ');
      if (ProgramHeaders[i].p_flags AND 4)=4 then write('R');
      if (ProgramHeaders[i].p_flags AND 2)=2 then write('W');
      if (ProgramHeaders[i].p_flags AND 1)=1 then write('E');
      writeln;
{$ENDIF}
      if (ProgramHeaders[i].p_flags AND 1)<>1 then
      begin
        Alignment:=ProgramHeaders[i].p_align;
        LoadAddress:=ProgramHeaders[i].p_vaddr;
        AlignedAddress:=Loadaddress AND -Alignment;
        AlignedEndAddress:=(Loadaddress+ProgramHeaders[i].p_memsz+Alignment-1) AND -Alignment;
        AlignedSize:=AlignedEndAddress-AlignedAddress;

{$IFDEF debug_execshieldfix}
        writeln('  Missing executable flag, fixing... ');
        writeln('    Aligned Start: '+inttohex(AlignedAddress,8));
        writeln('    Aligned End:   '+inttohex(AlignedEndAddress,8));
        writeln('    Aligned Size:  '+inttohex(AlignedSize,8));

        if mprotect(pointer(AlignedAddress),AlignedSize,7)=0 then
          writeln('  OK')
        else
          writeln('  ERROR!');
{$ELSE}
        mprotect(pointer(AlignedAddress),AlignedSize,7)
{$ENDIF}
      end;
    end;
  end;
end;

initialization
  fixsegments;
end.
