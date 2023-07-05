import ballerina/log;
import ballerina/http;

//API che richiama un BE Mocked


public function EMFindFornitureCompleteByTriplette(string bpem_code = "", string soggetto_cod = "", string societa_cod = "") returns map<json[]>|map<json>|error{

log:printDebug("EMFindFornitureCompleteByTriplette - Start Correctly -- BPME Code: " + bpem_code + ", Soggetto Code: " + soggetto_cod + ", Societa' Code: " + societa_cod + "\n");

xml request_message = xml `
<dat:EMExtractAllDatiFornByTripletteWithSoggetto xmlns:dat="http://ws.wso2.org/dataservice"><dat:bpem_cod>${bpem_code}</dat:bpem_cod><dat:soggetto_cod>${soggetto_cod}</dat:soggetto_cod><dat:societa_cod>${societa_cod}</dat:societa_cod></dat:EMExtractAllDatiFornByTripletteWithSoggetto>`;


http:Client interrogazioneDB = check new("http://localhost:9595/end-point/dbContratti");

map<json[]>|map<json> response = <map<json[]>|map<json>> check interrogazioneDB -> execute("post", "/", request_message);

log:printDebug("EMFindFornitureCompleteByTriplette - END Correctly");

return response;
  
   }

