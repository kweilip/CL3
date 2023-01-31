;;
;; ConfigReader.ahk by Danil Valov <https://github.com/danilvalov/adminhelper-for-samp-rp>
;; Simplified to load the only custom config settings.ini
;;

class ConfigReader {

  injectSysEnv(ConfigCollection) {
    ; https://autohotkey.com/board/topic/23547-iniwrite-and-eviroment-variables/
    EnvGet, A_USERPROFILE, USERPROFILE

    For SectionName, SectionValue in ConfigCollection {
      For FieldName, FieldValue in SectionValue {
        arrSlug := [].Concat(StrSplit(FieldValue, "|"))

        if(arrSlug[1] = "%UserProfile%"){
          arrSlug[1] := A_USERPROFILE
        }

        finalValue := arrSlug.Join("\")
        ConfigCollection[SectionName][FieldName] := finalValue
      }
    }

    Return ConfigCollection
  }

  parseIniValues(Values) {
    Result := {}

    SplitValues := StrSplit(Values, "`n")

    Loop, % SplitValues.MaxIndex()
    {
      SplitLine := StrSplit(SplitValues[A_Index], "=")
      Result[Trim(SplitLine[1])] := {}
      Result[Trim(SplitLine[1])] := Trim(SplitLine[2])
    }

    Return Result
  }

  readIniSection(IniFile, SectionName) {
    IniRead, SectionValues, % IniFile, % SectionName

    If (SectionValues && StrLen(SectionValues)) {
      Return this.parseIniValues(SectionValues)
    }
    Return False
  }

  updateConfig(IniFile, SectionName, Field, UpdatedValue){
    IniWrite, % UpdatedValue, % IniFile, % SectionName, % Field
    this.reloadConfig(IniFile)
  }

  reloadConfig(IniFile){
    Global Config ; The global Config object: `Config["Monitor"]["Brightness"]`

    Config := {}
    
    Config["ClipDataPath"] := this.readIniSection("settings.ini", "ClipDataPath")
    Config["weip"] := this.readIniSection("settings.ini", "weip")


    Config := this.injectSysEnv(Config)
  }

  __New() {
    this.reloadConfig("settings.ini")
    ; MsgBox, % st_printArr(Config) ; behave like JSON.stringify(arrConfig)

    ; To load some section as first level config: `Config := this.readIniSection("settings.ini", "Options")`
    ; To load the concatenated string as array: `Config["EnabledPlugins"] := StrSplit(Config["EnabledPlugins"], ",")`
    ; To load nested ini: `Config["modules"][ModuleName] := this.readIniSection("modules\" ModuleName "\settings.ini", "SectionName")`
    
  }
}

ConfigReader := new ConfigReader()
