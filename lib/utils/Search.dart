import '../model/file_model.dart';

String searchInJson(String json, String txt){

  String result='[';
  int len=json.length;
  for(int i=0;i<len-7;i++){
    if(json.substring(i,i+8)=="\"match\":"){
      bool found=false;
      for(int j=i+9;j<len;j++){
        bool ok=true;
        if(json.substring(j,j+3)=="\",\"")break;
        for(int j2=j;j2<len;j2++){
            if(j2-j>=txt.length)break;
            if(json.substring(j2,j2+3)=="\"\""){ok=false;break;}
          
            if(json[j2].toLowerCase()!=txt[j2-j].toLowerCase()){ok=false;break;}
              
          }
        if(ok==true){found=ok;break;}
      }
      if(found==false)continue;
      if(result.length>1)result+=",";
      for(int j=i+7;j<len-1;j++){
  
        if(json.substring(j,j+2)=="\"}"){
            result+="{"+json.substring(i,j+2);
            i=j;
            break;
        }
      }
    }
  }
  result+="]";
  return result;
}
List<FileModel> search(List<FileModel> json, String txt){
  List<FileModel> result = <FileModel>[];
  int len=json.length;
  for(int i=0;i<len;i++){
      //json[i].text = searchInJson(json[i].text,txt);
      result.add(json[i]);
  }
  
  return result;
}