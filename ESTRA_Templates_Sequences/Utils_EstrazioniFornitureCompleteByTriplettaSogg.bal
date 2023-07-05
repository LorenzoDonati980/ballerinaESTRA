import ballerina/log;

public function Utils_EstrazioniFornitureCompleteByTriplettaSogg(string bpem_code = "", string soggetto_cod = "", string societa_cod = "") returns json[]|json|error {

log:printDebug("Utils_EstrazioniFornitureCompleteByTriplettaSogg - Start Correctly -- BPME Code: " + bpem_code + ", Soggetto Code: " + soggetto_cod + ", Societa' Code: " + societa_cod);

map<json[]>|map<json> esitoTemplateForniture = check EMFindFornitureCompleteByTriplette(bpem_code,soggetto_cod,societa_cod);

json[]|json listaForniture = esitoTemplateForniture.get("listaForniture");


if listaForniture is json[] {
    log:printInfo("Risultato Query - Array, LogRisultato = " + listaForniture.toString());
}
else if listaForniture is json {
    log:printInfo("Risultato Query - Non Array, LogRisultato = " + listaForniture.toString());
}

log:printDebug("Utils_EstrazioniFornitureCompleteByTriplettaSogg - End Correctly");

return listaForniture;

}
