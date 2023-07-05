import ballerina/log;
import ballerina/http;


//ELENCO DEGLI USE CASE

map<json[]> caso1409666 = 
{
    "listaForniture" : [{
                "fornitura_cod": "3670014",
                "settore_cod": "ENELE",
                "via_fornitura": "VIA DEL CAMPOREGIO,5",
                "comune_fornitura": "SIENA",
                "stato": "APERTO",
                "pdrpod": "IT001E46998459"
            }, {
                "fornitura_cod": "3670022",
                "settore_cod": "ENELE",
                "via_fornitura": "VIA DEL CAMPOREGIO,5",
                "comune_fornitura": "SIENA",
                "stato": "APERTO",
                "pdrpod": "IT001E46998457"
            }
        ]
};


map<json[]> caso199999 = 
{
    "listaForniture" : [{
                "fornitura_cod": "3670014",
                "settore_cod": "ENELE",
                "via_fornitura": "VIA DEL CAMPOREGIO,5",
                "comune_fornitura": "SIENA",
                "stato": "APERTO",
                "pdrpod": "IT001E46998459"
            }, {
                "fornitura_cod": "3670022",
                "settore_cod": "ENELE",
                "via_fornitura": "VIA DEL CAMPOREGIO,5",
                "comune_fornitura": "SIENA",
                "stato": "APERTO",
                "pdrpod": "IT001E46998457"
            },
            {
                "fornitura_cod": "49000",
                "settore_cod": "GM",
                "via_fornitura": "VIA DEL PO', 90",
                "comune_fornitura": "TORINO",
                "stato": "APERTO",
                "pdrpod": "IT001E46928459"
            }, {
                "fornitura_cod": "3670022",
                "settore_cod": "GM",
                "via_fornitura": "VIA DEL PO', 90",
                "comune_fornitura": "TORINO",
                "stato": "CHIUSO",
                "pdrpod": "IT001E46938457"
            }
        ]
};

map<json> caso7276569 = 
{
"listaForniture" :{
            "fornitura_cod": "3670016",
            "settore_cod": "ENELE",
            "via_fornitura": "VIA ANTONIO VIVALDI,2",
            "comune_fornitura": "SIENA",
            "stato": "APERTO",
            "pdrpod": "IT001E46998459"
    }
};

map<json[]> listaFornitureVuota = {"listaForniture" : []};



service /end\-point on new http:Listener(9595){

resource function post dbContratti(xml payload) returns map<json[]>|map<json>|error{

    log:printDebug("Chiamata POST a DB Contratti - Start");

    string soggetto_cod = payload.children()[1].data();


    log:printInfo("Recuperata la lista forniture corrispondente al soggetto con codice: " + soggetto_cod);

    if soggetto_cod.equalsIgnoreCaseAscii("1409666") {
            return caso1409666;
    }

    else if soggetto_cod.equalsIgnoreCaseAscii("7276569"){
            return caso7276569;
        }

    else if soggetto_cod.equalsIgnoreCaseAscii("199999"){
            return caso199999;
    }

    return listaFornitureVuota;
    
    }


}