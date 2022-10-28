// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static m0(howMany) => "${Intl.plural(howMany, one: 'Merchant', other: 'Merchants')}";

  static m1(howMany) => "${Intl.plural(howMany, one: 'Transazione', other: 'Transazioni')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "acceptTerms" : MessageLookupByLibrary.simpleMessage("Per proseguire devi accettare i termini"),
    "accessSecurity" : MessageLookupByLibrary.simpleMessage("Accesso e Sicurezza"),
    "accessType" : MessageLookupByLibrary.simpleMessage("Scegli la modalità di accesso all\'app"),
    "actualPassword" : MessageLookupByLibrary.simpleMessage("Password attuale"),
    "addQrCode" : MessageLookupByLibrary.simpleMessage("Aggiungi QR"),
    "allocateVouchers" : MessageLookupByLibrary.simpleMessage("Allocazione Buoni  "),
    "allowLocalization" : MessageLookupByLibrary.simpleMessage("È necessario autorizzare la localizzazione per visualizzare la lista degli affiliati nei paraggi"),
    "allowPhoneCamera" : MessageLookupByLibrary.simpleMessage("È necessario autorizzare l\'uso della fotocamera per usufruire di questo servizio"),
    "answerNo" : MessageLookupByLibrary.simpleMessage("No"),
    "answerYes" : MessageLookupByLibrary.simpleMessage("Si"),
    "applyText" : MessageLookupByLibrary.simpleMessage("Invia"),
    "avaibleBalance" : MessageLookupByLibrary.simpleMessage("Saldo disponibile"),
    "availableVouchers" : MessageLookupByLibrary.simpleMessage("Vouchers disponibili"),
    "backTo" : MessageLookupByLibrary.simpleMessage("Torna alla "),
    "backToTransferVouchers" : MessageLookupByLibrary.simpleMessage("Torna al trasferimento vouchers"),
    "camera" : MessageLookupByLibrary.simpleMessage("Camera"),
    "cancel" : MessageLookupByLibrary.simpleMessage("Annulla"),
    "cash" : MessageLookupByLibrary.simpleMessage("Cassa "),
    "cashNumber" : MessageLookupByLibrary.simpleMessage("Numero cassa"),
    "causal" : MessageLookupByLibrary.simpleMessage("Causale"),
    "completed" : MessageLookupByLibrary.simpleMessage("Completato"),
    "confirm" : MessageLookupByLibrary.simpleMessage("Conferma"),
    "contactName" : MessageLookupByLibrary.simpleMessage("Nome Referente"),
    "contactSurname" : MessageLookupByLibrary.simpleMessage("Cognome Referente"),
    "continueScanning" : MessageLookupByLibrary.simpleMessage("Vuoi continuare a scansionare?"),
    "createNewQrCode" : MessageLookupByLibrary.simpleMessage("Crea nuovo"),
    "customerService" : MessageLookupByLibrary.simpleMessage("Assistenza"),
    "date" : MessageLookupByLibrary.simpleMessage("Data"),
    "delete" : MessageLookupByLibrary.simpleMessage("Elimina"),
    "description" : MessageLookupByLibrary.simpleMessage("Descrizione"),
    "download" : MessageLookupByLibrary.simpleMessage("Scarica"),
    "downloadCompleted" : MessageLookupByLibrary.simpleMessage("Download completato"),
    "email" : MessageLookupByLibrary.simpleMessage("Email"),
    "employee" : MessageLookupByLibrary.simpleMessage("Employee"),
    "endDate" : MessageLookupByLibrary.simpleMessage("Data di Fine"),
    "enterEmail" : MessageLookupByLibrary.simpleMessage("Inserisci la tua email"),
    "error" : MessageLookupByLibrary.simpleMessage("Errore"),
    "errorNoDetails" : MessageLookupByLibrary.simpleMessage("Non è stato possibile recuperare i dettagli."),
    "existingQrCode" : MessageLookupByLibrary.simpleMessage("Esiste già una cassa con questo numero,\nper favore selezionare un altro numero"),
    "expirationDate" : MessageLookupByLibrary.simpleMessage("Scadenza"),
    "exportHistory" : MessageLookupByLibrary.simpleMessage("Esporta Storico"),
    "faq" : MessageLookupByLibrary.simpleMessage("FAQ"),
    "fingerPrint" : MessageLookupByLibrary.simpleMessage("FingerPrint"),
    "fingerPrintSet" : MessageLookupByLibrary.simpleMessage("L\'accesso con impronta digitale è stato impostato"),
    "forgotThe" : MessageLookupByLibrary.simpleMessage("Hai dimenticato la "),
    "forgottenPin" : MessageLookupByLibrary.simpleMessage("Hai dimenticato il PIN? Effettua il "),
    "from" : MessageLookupByLibrary.simpleMessage(" da "),
    "gallery" : MessageLookupByLibrary.simpleMessage("Galleria"),
    "generalErrorRetry" : MessageLookupByLibrary.simpleMessage("Si è verificato un errore, riprovare"),
    "genericTransaction" : MessageLookupByLibrary.simpleMessage("Transazione generica"),
    "history" : MessageLookupByLibrary.simpleMessage("Storico"),
    "homepage" : MessageLookupByLibrary.simpleMessage("Homepage"),
    "imageTooLarge" : MessageLookupByLibrary.simpleMessage("L\'immagine inserita è troppo grande,\ndimensione massima consentita: "),
    "import" : MessageLookupByLibrary.simpleMessage("Importo"),
    "inUseMode" : MessageLookupByLibrary.simpleMessage("Modalità già in uso"),
    "infoQrCode" : MessageLookupByLibrary.simpleMessage("Scansiona il codice QR"),
    "insertANumber" : MessageLookupByLibrary.simpleMessage("Inserisci un numero"),
    "insertInvitationCode" : MessageLookupByLibrary.simpleMessage("Inserire il codice di invito"),
    "insertPassword" : MessageLookupByLibrary.simpleMessage("Inserire una password"),
    "insertPin" : MessageLookupByLibrary.simpleMessage("Inserire il PIN"),
    "insertResearchRange" : MessageLookupByLibrary.simpleMessage("Inserire un raggio di ricerca"),
    "insertStartEndDate" : MessageLookupByLibrary.simpleMessage("Inserisci una data di inizio e di fine"),
    "insertValidTimeRange" : MessageLookupByLibrary.simpleMessage("Per favore inserisci un intervallo valido"),
    "invalidCode" : MessageLookupByLibrary.simpleMessage("Il codice inserito non è valido"),
    "invalidEmail" : MessageLookupByLibrary.simpleMessage("Inserire un\'email"),
    "invalidEmailOrPassword" : MessageLookupByLibrary.simpleMessage("Email e/o Password errati"),
    "invalidPassword" : MessageLookupByLibrary.simpleMessage("Inserire una password valida"),
    "invalidPasswordExplanation" : MessageLookupByLibrary.simpleMessage("La password deve essere di almeno 8 caratteri,\navere almeno una lettera maiuscola,\nuna lettera minuscola, e un numero"),
    "invalidQrCode" : MessageLookupByLibrary.simpleMessage("Codice Qr non valido"),
    "invitationCodeText" : MessageLookupByLibrary.simpleMessage("Codice di invito"),
    "invitationText" : MessageLookupByLibrary.simpleMessage("Hai un codice di invito?"),
    "kM" : MessageLookupByLibrary.simpleMessage(" km"),
    "login" : MessageLookupByLibrary.simpleMessage("Entra"),
    "logout" : MessageLookupByLibrary.simpleMessage("Logout"),
    "logoutSuccesful" : MessageLookupByLibrary.simpleMessage("Il logout è stato effettuato correttamente"),
    "mailSent" : MessageLookupByLibrary.simpleMessage("Ti abbiamo inoltrato una mail con la procedura di recupero password."),
    "matricola" : MessageLookupByLibrary.simpleMessage("Matricola"),
    "merchant" : m0,
    "merchantShowcase" : MessageLookupByLibrary.simpleMessage("Vetrina affiliati"),
    "merchantTransfer" : MessageLookupByLibrary.simpleMessage("Trasferimento ad affiliati"),
    "modify" : MessageLookupByLibrary.simpleMessage("Modifica"),
    "modifySuccessful" : MessageLookupByLibrary.simpleMessage("La modifica è stata effettuata con successo"),
    "mrcAddress" : MessageLookupByLibrary.simpleMessage("Indirizzo"),
    "mrcBusinessName" : MessageLookupByLibrary.simpleMessage("Ragione Sociale"),
    "mrcCity" : MessageLookupByLibrary.simpleMessage("Città"),
    "mrcDetails" : MessageLookupByLibrary.simpleMessage("Dettagli Affiliato"),
    "mrcName" : MessageLookupByLibrary.simpleMessage("Nominativo"),
    "mrcPhone" : MessageLookupByLibrary.simpleMessage("Telefono"),
    "mrcProv" : MessageLookupByLibrary.simpleMessage("Provincia"),
    "mrcZipCode" : MessageLookupByLibrary.simpleMessage("Cap"),
    "name" : MessageLookupByLibrary.simpleMessage("Nome"),
    "newPassword" : MessageLookupByLibrary.simpleMessage("Nuova Password"),
    "newQrCode" : MessageLookupByLibrary.simpleMessage("Nuovo QR Code"),
    "noBiometricsOnDevice" : MessageLookupByLibrary.simpleMessage("Su questo dispositivo non è presente un lettore biometrico"),
    "noMerchantFound" : MessageLookupByLibrary.simpleMessage("Non sono stati trovati affiliati"),
    "noQrCodeYet" : MessageLookupByLibrary.simpleMessage("Non ci sono ancora QRcode"),
    "noSamePassword" : MessageLookupByLibrary.simpleMessage("La vecchia password e la nuova\npassword non possono coincidere"),
    "noTransactionToExport" : MessageLookupByLibrary.simpleMessage("Non ci sono transazioni da esportare"),
    "noTransactionsFound" : MessageLookupByLibrary.simpleMessage("Non sono state trovate transazioni in questo intervallo"),
    "nonExistingQrCode" : MessageLookupByLibrary.simpleMessage("Il QR code non è più disponibile."),
    "normalAccess" : MessageLookupByLibrary.simpleMessage("Accesso normale"),
    "ofString" : MessageLookupByLibrary.simpleMessage(" di "),
    "officeName" : MessageLookupByLibrary.simpleMessage("Nome Ufficio"),
    "okButton" : MessageLookupByLibrary.simpleMessage("OK"),
    "openApp" : MessageLookupByLibrary.simpleMessage("Apri l\'applicazione per i dettagli"),
    "openMap" : MessageLookupByLibrary.simpleMessage("Mappa"),
    "orderSummary" : MessageLookupByLibrary.simpleMessage("Riepilogo Ordine"),
    "password" : MessageLookupByLibrary.simpleMessage("Password"),
    "passwordChange" : MessageLookupByLibrary.simpleMessage("Cambia Password"),
    "passwordChanged" : MessageLookupByLibrary.simpleMessage("La password è stata cambiata"),
    "passwordMustCoincide" : MessageLookupByLibrary.simpleMessage("Le password devono coincidere"),
    "passwordRecovery" : MessageLookupByLibrary.simpleMessage("Recupera password"),
    "passwordResetError" : MessageLookupByLibrary.simpleMessage("Si è verificato un errore,\ncontrollare che il link sia valido."),
    "passwordRestored" : MessageLookupByLibrary.simpleMessage("Password ripristinata!"),
    "pay" : MessageLookupByLibrary.simpleMessage("Paga"),
    "payment" : MessageLookupByLibrary.simpleMessage("Pagamento"),
    "periodSelect" : MessageLookupByLibrary.simpleMessage("Seleziona un periodo"),
    "pinAccess" : MessageLookupByLibrary.simpleMessage("PIN"),
    "pinRemoved" : MessageLookupByLibrary.simpleMessage("Il PIN è stato rimosso"),
    "pinSet" : MessageLookupByLibrary.simpleMessage("Il PIN è stato impostato"),
    "profileSettings" : MessageLookupByLibrary.simpleMessage("Impostazioni profilo"),
    "qrCodeCash" : MessageLookupByLibrary.simpleMessage("QR code cassa "),
    "qrCodeDeleted" : MessageLookupByLibrary.simpleMessage("Il QR code è stato eliminato."),
    "qrList" : MessageLookupByLibrary.simpleMessage("Lista QRCode"),
    "qrTransfer" : MessageLookupByLibrary.simpleMessage("QR Trasferimenti"),
    "quantity" : MessageLookupByLibrary.simpleMessage("Quantità"),
    "received" : MessageLookupByLibrary.simpleMessage("Hai ricevuto "),
    "recipient" : MessageLookupByLibrary.simpleMessage("Affiliato destinatario"),
    "recipientSender" : MessageLookupByLibrary.simpleMessage("Beneficiario mittente"),
    "reciveVoucherFrom" : MessageLookupByLibrary.simpleMessage("Ricezione buoni da "),
    "reconnect" : MessageLookupByLibrary.simpleMessage("Riconnettiti"),
    "redeemVoucher" : MessageLookupByLibrary.simpleMessage("Riscatto buoni"),
    "remainVouchers" : MessageLookupByLibrary.simpleMessage("Voucher rimasti"),
    "removedFingerMode" : MessageLookupByLibrary.simpleMessage("L\'accesso con impronta digitale è stato rimosso"),
    "repeatPassword" : MessageLookupByLibrary.simpleMessage("Ripeti password"),
    "repeatPin" : MessageLookupByLibrary.simpleMessage("Ripeti PIN"),
    "researchRange" : MessageLookupByLibrary.simpleMessage(" km (Raggio di ricerca)"),
    "researchRangeMoreThanZero" : MessageLookupByLibrary.simpleMessage("Inserire un raggio di ricerca\nmaggiore di zero"),
    "resetPassword" : MessageLookupByLibrary.simpleMessage("Reimposta Password"),
    "resetPasswordDone" : MessageLookupByLibrary.simpleMessage("La password è stata reimpostata"),
    "save" : MessageLookupByLibrary.simpleMessage("Salva"),
    "scanQrCode" : MessageLookupByLibrary.simpleMessage("Questo è il risultato dello scan: "),
    "scanningQrCode" : MessageLookupByLibrary.simpleMessage("Scansione del Codice Qr"),
    "selectAtLeastOneVoucher" : MessageLookupByLibrary.simpleMessage("Selezionare almeno un buono"),
    "selectQuantity" : MessageLookupByLibrary.simpleMessage("Seleziona la quantità"),
    "selectedMerchant" : MessageLookupByLibrary.simpleMessage("Affiliato"),
    "selectedVoucher" : MessageLookupByLibrary.simpleMessage("Buoni selezionati"),
    "settings" : MessageLookupByLibrary.simpleMessage("Impostazioni"),
    "showProfile" : MessageLookupByLibrary.simpleMessage("Visualizza profilo"),
    "signup" : MessageLookupByLibrary.simpleMessage("Registrati"),
    "signupAccept" : MessageLookupByLibrary.simpleMessage("Accetta"),
    "startDate" : MessageLookupByLibrary.simpleMessage("Data di inizio"),
    "surname" : MessageLookupByLibrary.simpleMessage("Cognome"),
    "termsConditions" : MessageLookupByLibrary.simpleMessage("Termini e Condizioni"),
    "title" : MessageLookupByLibrary.simpleMessage("Vouchain wallet app"),
    "totalSelected" : MessageLookupByLibrary.simpleMessage("Totale selezionato"),
    "touchSensorForAuth" : MessageLookupByLibrary.simpleMessage("Tocca il sensore per autenticarti"),
    "transaction" : m1,
    "transactionHistory" : MessageLookupByLibrary.simpleMessage("Storico transazioni"),
    "transactionNumber" : MessageLookupByLibrary.simpleMessage("Transazione n°"),
    "transactionReceived" : MessageLookupByLibrary.simpleMessage("Hai ricevuto una nuova transazione"),
    "transactionsNotification" : MessageLookupByLibrary.simpleMessage("Notifiche transazioni"),
    "transferVouchers" : MessageLookupByLibrary.simpleMessage("Trasferisci buoni"),
    "userNotActive" : MessageLookupByLibrary.simpleMessage("Utente ancora non attivato"),
    "valueSign" : MessageLookupByLibrary.simpleMessage(" €"),
    "vouchain" : MessageLookupByLibrary.simpleMessage("Vouchain"),
    "voucherAccredit" : MessageLookupByLibrary.simpleMessage("Accredito di buoni"),
    "voucherTransferComplete" : MessageLookupByLibrary.simpleMessage("Trasferimento voucher completato"),
    "voucherTransferError" : MessageLookupByLibrary.simpleMessage("Voucher Scaduto. Errore nel trasferimento voucher "),
    "voucherTransferTo" : MessageLookupByLibrary.simpleMessage("Trasferimento di buoni verso "),
    "wallet" : MessageLookupByLibrary.simpleMessage("Wallet"),
    "walletManagement" : MessageLookupByLibrary.simpleMessage("Gestione Wallet"),
    "walletValue" : MessageLookupByLibrary.simpleMessage("Valore"),
    "Status" : MessageLookupByLibrary.simpleMessage("Stato"),
    "wrongPassword" : MessageLookupByLibrary.simpleMessage("La password attuale non è corretta, riprovare"),
    "wrongPin" : MessageLookupByLibrary.simpleMessage("PIN errato"),
    "yourWallet" : MessageLookupByLibrary.simpleMessage("Il Tuo Wallet"),
     "okicon" : MessageLookupByLibrary.simpleMessage("Disponibile"),
      "redicon" : MessageLookupByLibrary.simpleMessage("Scaduto")
  };
}
