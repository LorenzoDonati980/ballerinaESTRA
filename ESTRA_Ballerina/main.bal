import ballerina/http;
import ballerina/io;
import ballerina/log;
import lorenzodonati/ESTRA_Templates_Sequences;
import ballerina/time;


type errorMessage record {
string message;
string details;
time:Utc timeStamp;
};

type bodyError record {|
*http:NotAcceptable;
errorMessage body;
|};

function generateErrorBody(string message) returns bodyError{
     
     bodyError errorMessage = 
            {
                body: { 
                    message: "BODY_ERROR",
                    details: message,
                    timeStamp: time:utcNow()
                    }
                };
    return errorMessage;
}


service /neta on new http:Listener(8181) {

    resource function post EM/areaclienti/contratti/contrattiAllSingoloSoggettoEM(http:Request req) returns map<json[]>|json|bodyError|error{

        string descrizioneSocieta = "";
        string soggetto_cod = "";
        string societa_cod = "";
        string bpme_code = "";
        map<json[]> mappaForniture = {"listaForniture":[]};
       
        log:printDebug("NETA_ES_AC_contrattiAllSingoloSoggettoEM - Start Correctly");

        json bodyReq;
        json|http:ClientError checkConversionInJSON =  req.getJsonPayload();

//Verifica che non ci siano errori nel body della Request (es: body vuoto)

        if checkConversionInJSON is http:ClientError {
            
            return generateErrorBody("Si e' verificato un errore nel payload della richiesta, perfavore ricontrollare!");
        } 
        else {
            
            bodyReq = check req.getJsonPayload();
        }
        
        //Verifico se ci sono tutti e due i parametri essenziali
        if bodyReq.codiceSoggetto is error || bodyReq.codiceSocieta is error {

            return generateErrorBody("Sembra che manchi un parametro essenziale nel body, perfavore ricontrollare!");
        }

        //Si preparano i parametri per richiamare il template
        soggetto_cod =  check bodyReq.codiceSoggetto;
        societa_cod =  check bodyReq.codiceSocieta;
        bpme_code = "90000002871725788";


        //Richiamiamo il template per ottenere la lista delle forniture a partire dalla tripletta codice bpme, codice soggetto e codice societa
        json[]|json|error listaForniture = ESTRA_Templates_Sequences:Utils_EstrazioniFornitureCompleteByTriplettaSogg(bpme_code, soggetto_cod, societa_cod);

        //Settiamo la descrizione della societa in base al controllo sul codice_Societa
        if societa_cod is "287"{
            descrizioneSocieta = "Estra";
        } 
        else{ 
            descrizioneSocieta = "Prometeo";
        }

        //verifichiamo il numero di forniture collegate al soggetto
        if listaForniture is json[] {
            json[] listaTemporanea = [];
            //se maggiore di uno, componiamo la risposta finale
            foreach var fornitura in listaForniture {
                log:printInfo("Fornitura attuale: " + fornitura.toString());
                json fornituraAttuale =                   
		                        {
		                        	"codiceCliente" : soggetto_cod,
		                        	"settore" : check fornitura.settore_cod,
		                        	"societa" : societa_cod,
		                        	"codiceFornitura" : check fornitura.fornitura_cod,
		                        	"descrizioneSocieta" : descrizioneSocieta,
		                        	"viaFornitura" : check fornitura.via_fornitura,
		                        	"comuneFornitura" : check fornitura.comune_fornitura,
		                        	"statoFornitura" : check fornitura.stato,
		                        	"pdrpod" : check fornitura.pdrpod
		                        };
            listaTemporanea.push(fornituraAttuale);

            }
            mappaForniture["listaForniture"] = listaTemporanea;
            return mappaForniture;
        } 
        //se si tratta di una sola fornitura, allora si restituisce l'unica fornitura recuperata
        else if listaForniture is json {
                                
                log:printInfo("Fornitura attuale: " + listaForniture.toString());
                json fornitura = {                  
		                        "listaForniture": {
		                        	"codiceCliente" : soggetto_cod,
		                        	"settore" : check listaForniture.settore_cod,
		                        	"societa" : societa_cod,
		                        	"codiceFornitura" : check listaForniture.fornitura_cod,
		                        	"descrizioneSocieta" : descrizioneSocieta,
		                        	"viaFornitura" : check listaForniture.via_fornitura,
		                        	"comuneFornitura" : check listaForniture.comune_fornitura,
		                        	"statoFornitura" : check listaForniture.stato,
		                        	"pdrpod" : check listaForniture.pdrpod
		                        }
                
            };

            return fornitura;
        }
    }



    resource function get estra/app/contratti/contrattiAllNew/[string 'record]() returns string{
        log:printInfo("Sto dentro la contrattiAllNew con record: " + 'record);
        string message = "API richiamata con successo";
        return message;
    }
    
}



public function main() {
    io:println("Inizializzazione Servizi ESTRA completata!\n");
    io:println("/neta/EM/areaclienti/contratti/contrattiAllSingoloSoggettoEM: porta: 8181, metodo: POST\n");
    io:println("/neta/estra/app/contratti/contrattiAllNew: porta: 8181, metodo: GET\n");       
}
