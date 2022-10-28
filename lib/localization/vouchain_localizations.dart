import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:vouchain_wallet_app/localization/l10n/messages_all.dart';

class VouchainLocalizations {
  /// Initialize localization systems and messages
  static Future<VouchainLocalizations> load(Locale locale) async {
    // If we're given "en_US", we'll use it as-is. If we're
    // given "en", we extract it and use it.
    final String localeName =
        locale.countryCode == null || locale.countryCode.isEmpty
            ? locale.languageCode
            : locale.toString();
    // We make sure the locale name is in the right format e.g.
    // converting "en-US" to "en_US".
    final String canonicalLocaleName = Intl.canonicalizedLocale(localeName);
    // Load localized messages for the current locale.
    await initializeMessages(canonicalLocaleName);
    // Force the locale in Intl.
    Intl.defaultLocale = canonicalLocaleName;
    return VouchainLocalizations();
  }

  /// Retrieve localization resources for the widget tree
  /// corresponding to the given `context`
  static VouchainLocalizations of(BuildContext context) =>
      Localizations.of<VouchainLocalizations>(context, VouchainLocalizations);

  String get title => Intl.message(
        'Vouchain wallet app',
        name: 'title',
        desc: 'App title',
      );

  //drawer menu
  String get vouchain => Intl.message(
        'Vouchain',
        name: 'vouchain',
      );

  String get employee => Intl.message(
        'Beneficiario',
        name: 'employee',
      );

  String merchant(int howMany) => Intl.plural(
        howMany,
        one: 'Affiliato',
        other: 'Affiliati',
        args: [howMany],
        name: 'merchant',
      );

  String get walletManagement => Intl.message(
        'Gestione Wallet',
        name: 'walletManagement',
      );

  String get merchantShowcase => Intl.message(
        'Vetrina affiliati',
        name: 'merchantShowcase',
      );

  String get noMerchantFound => Intl.message(
        "Non sono stati trovati affiliati",
        name: 'noMerchantFound',
      );

  String get merchantTransfer => Intl.message(
        'Trasferimento ad affiliati',
        name: 'merchantTransfer',
      );

  String get qrTransfer => Intl.message(
        'QR Trasferimenti',
        name: 'qrTransfer',
      );

  String get qrList => Intl.message(
        "Lista QRCode",
        name: 'qrList',
      );

  String get transactionHistory => Intl.message(
        'Storico transazioni',
        name: 'transactionHistory',
      );

  String get profileSettings => Intl.message(
        'Impostazioni profilo',
        name: 'profileSettings',
      );

  String get faq => Intl.message(
        'FAQ',
        name: 'faq',
      );

  String get customerService => Intl.message(
        'Assistenza',
        name: 'customerService',
      );

  String get modify => Intl.message(
        'Modifica',
        name: 'modify',
      );

  String get import => Intl.message(
        'Importo',
        name: 'import',
      );

  String get description => Intl.message(
        'Descrizione',
        name: 'description',
      );

  String get modifySuccessful => Intl.message(
        "La modifica è stata effettuata con successo",
        name: 'modifySuccessful',
      );

  String get cancel => Intl.message(
        "Annulla",
        name: 'cancel',
      );

  String get logout => Intl.message(
        'Logout',
        name: 'logout',
      );

  //Homepage
  String get backTo => Intl.message(
        'Torna alla ',
        name: 'backTo',
      );

  String get homepage => Intl.message(
        'Homepage',
        name: 'homepage',
      );

  //Login
  String get login => Intl.message(
        'Entra',
        name: 'login',
      );

  String get invitationText => Intl.message(
        'Hai un codice di invito?',
        name: 'invitationText',
      );

  String get email => Intl.message(
        'Email',
        name: 'email',
      );

  String get password => Intl.message(
        'Password',
        name: 'password',
      );

  //SignUp
  String get signup => Intl.message(
        'Registrati',
        name: 'signup',
      );

  String get signupAccept => Intl.message(
        'Accetta',
        name: 'signupAccept',
      );

  String get termsConditions => Intl.message(
        'Termini e Condizioni',
        name: 'termsConditions',
      );

  String get name => Intl.message(
        'Nome',
        name: 'name',
      );

  String get officeName => Intl.message(
        "Nome Ufficio",
        name: 'officeName',
      );

  String get surname => Intl.message(
        'Cognome',
        name: 'surname',
      );

  String get matricola => Intl.message(
        'Matricola',
        name: 'matricola',
      );

  String get repeatPassword => Intl.message(
        'Ripeti password',
        name: 'repeatPassword',
      );

  //Invitation code
  String get invitationCodeText => Intl.message(
        'Codice di invito',
        name: 'invitationCodeText',
      );

  String get applyText => Intl.message(
        'Invia',
        name: 'applyText',
      );

  //Password recovery
  String get passwordRecovery => Intl.message(
        'Recupera password',
        name: 'passwordRecovery',
      );

  String get enterEmail => Intl.message(
        'Inserisci la tua email',
        name: 'enterEmail',
      );

  String get confirm => Intl.message(
        'Conferma',
        name: 'confirm',
      );

  //Wallet
  String get yourWallet => Intl.message(
        'Il Tuo Wallet',
        name: 'yourWallet',
      );

String get okicon => Intl.message(
        'Disponibile',
        name: 'okicon',
      );
  String get redicon => Intl.message(
        'Scaduto',
        name: 'redicon',
      );    
  String get walletValue => Intl.message(
        'Valore',
        name: 'walletValue',
      );

       String get Status => Intl.message(
        'Stato',
        name: 'Status',
      ); 

  String get expirationDate => Intl.message(
        'Scadenza',
        name: 'expirationDate',
      );

  String get download => Intl.message(
        "Scarica",
        name: 'download',
      );

  String get downloadCompleted => Intl.message(
        'Download completato',
        name: 'downloadCompleted',
      );

  String get startDate => Intl.message(
        "Data di inizio",
        name: 'startDate',
      );

  String get endDate => Intl.message(
        "Data di Fine",
        name: 'endDate',
      );

  String get date => Intl.message(
        "Data",
        name: 'date',
      );

  String get insertStartEndDate => Intl.message(
        'Inserisci una data di inizio e di fine',
        name: 'insertStartEndDate',
      );

  String get insertValidTimeRange => Intl.message(
        'Per favore inserisci un intervallo valido',
        name: 'insertValidTimeRange',
      );

  String get periodSelect => Intl.message(
        "Seleziona un periodo",
        name: 'periodSelect',
      );

  String get quantity => Intl.message(
        'Quantità',
        name: 'quantity',
      );

  //VoucherTransfer

  String get allocateVouchers => Intl.message(
        'Allocazione Buoni ',
        name: 'allocateVouchers',
      );

  String get availableVouchers => Intl.message(
        'Vouchers disponibili',
        name: 'availableVouchers',
      );

  //Errors
  String get invalidPassword => Intl.message(
        'Inserire una password valida',
        name: 'invalidPassword',
      );

  String get invalidPasswordExplanation => Intl.message(
        'La password deve essere di almeno 8 caratteri,\navere almeno '
        'una lettera maiuscola,\nuna lettera minuscola, e un numero',
        name: 'invalidPasswordExplanation',
      );

  String get passwordMustCoincide => Intl.message(
        'Le password devono coincidere',
        name: 'passwordMustCoincide',
      );

  String get invalidEmail => Intl.message(
        'Inserire un\'email',
        name: 'invalidEmail',
      );

  String get error => Intl.message(
        "Errore",
        name: 'error',
      );

  String get generalErrorRetry => Intl.message(
        "Si è verificato un errore, riprovare",
        name: 'generalErrorRetry',
      );

  String get invalidCode => Intl.message(
        'Il codice inserito non è valido',
        name: 'invalidCode',
      );

  String get invalidEmailOrPassword => Intl.message(
        'Email e/o Password errati',
        name: 'invalidEmailOrPassword',
      );

  //Qr Code
  String get scanQrCode => Intl.message(
        'Questo è il risultato dello scan: ',
        name: 'scanQrCode',
      );

  String get scanningQrCode => Intl.message(
        "Scansione del Codice Qr",
        name: 'scanningQrCode',
      );

  String get continueScanning => Intl.message(
        'Vuoi continuare a scansionare?',
        name: 'continueScanning',
      );

  String get infoQrCode => Intl.message(
        "Scansiona il codice QR",
        name: 'infoQrCode',
      );

  String get invalidQrCode => Intl.message(
        'Codice Qr non valido',
        name: 'invalidQrCode',
      );

  String get addQrCode => Intl.message(
        "Aggiungi QR",
        name: 'addQrCode',
      );

  //MerchantShowcase
  String get selectedMerchant => Intl.message(
        "Affiliato",
        name: 'selectedMerchant',
      );

  String get transferVouchers => Intl.message(
        "Trasferisci buoni",
        name: 'transferVouchers',
      );

  String get wallet => Intl.message(
        'Wallet',
        name: 'wallet',
      );

  String get payment => Intl.message(
        'Pagamento',
        name: 'payment',
      );

  String get pay => Intl.message(
        "Paga",
        name: 'pay',
      );

  String transaction(int howMany) => Intl.plural(
        howMany,
        one: 'Transazione',
        other: 'Transazioni',
        args: [howMany],
        name: 'transaction',
      );

  //MrcDetails

  String get mrcDetails => Intl.message(
        'Dettagli Affiliato',
        name: 'mrcDetails',
      );

  String get mrcName => Intl.message(
        'Nominativo',
        name: 'mrcName',
      );

  String get mrcBusinessName => Intl.message(
        'Ragione Sociale',
        name: 'mrcBusinessName',
      );

  String get mrcAddress => Intl.message(
        'Indirizzo',
        name: 'mrcAddress',
      );

  String get mrcPhone => Intl.message(
        "Telefono",
        name: 'mrcPhone',
      );

  String get contactName => Intl.message(
        "Nome Referente",
        name: 'contactName',
      );

  String get contactSurname => Intl.message(
        "Cognome Referente",
        name: 'contactSurname',
      );

  String get mrcCity => Intl.message(
        'Città',
        name: 'mrcCity',
      );

  String get mrcProv => Intl.message(
        'Provincia',
        name: 'mrcProv',
      );

  String get gallery => Intl.message(
        'Galleria',
        name: 'gallery',
      );

  String get mrcZipCode => Intl.message(
        'Cap',
        name: 'mrcZipCode',
      );

  String get backToTransferVouchers => Intl.message(
        'Torna al trasferimento vouchers',
        name: 'backToTransferVouchers',
      );

  String get accessSecurity => Intl.message(
        'Accesso e Sicurezza',
        name: 'accessSecurity',
      );

  String get accessType => Intl.message(
        'Scegli la modalità di accesso all\'app',
        name: 'accessType',
      );

  String get normalAccess => Intl.message(
        'Accesso normale',
        name: 'normalAccess',
      );

  String get fingerPrint => Intl.message(
        'FingerPrint',
        name: 'fingerPrint',
      );

  String get pinAccess => Intl.message(
        'PIN',
        name: 'pinAccess',
      );

  String get repeatPin => Intl.message(
        "Ripeti PIN",
        name: 'repeatPin',
      );

  String get insertPin => Intl.message(
        "Inserire il PIN",
        name: 'insertPin',
      );

  String get forgottenPin => Intl.message(
        'Hai dimenticato il PIN? Effettua il ',
        name: 'forgottenPin',
      );

  String get wrongPin => Intl.message(
        "PIN errato",
        name: 'wrongPin',
      );

  String get inUseMode => Intl.message(
        'Modalità già in uso',
        name: 'inUseMode',
      );

  String get okButton => Intl.message(
        'OK',
        name: 'okButton',
      );

  String get removedFingerMode => Intl.message(
        'L\'accesso con impronta digitale è stato rimosso',
        name: 'removedFingerMode',
      );

  String get pinSet => Intl.message(
        'Il PIN è stato impostato',
        name: 'pinSet',
      );

  String get pinRemoved => Intl.message(
        "Il PIN è stato rimosso",
        name: 'pinRemoved',
      );

  String get passwordChanged => Intl.message(
        'La password è stata cambiata',
        name: 'passwordChanged',
      );

  String get wrongPassword => Intl.message(
        'La password attuale non è corretta, riprovare',
        name: 'wrongPassword',
      );

  String get noSamePassword => Intl.message(
        "La vecchia password e la nuova\npassword non possono coincidere",
        name: 'noSamePassword',
      );

  String get resetPassword => Intl.message(
        "Reimposta Password",
        name: 'resetPassword',
      );

  String get resetPasswordDone => Intl.message(
        "La password è stata reimpostata",
        name: 'resetPasswordDone',
      );

  String get insertPassword =>
      Intl.message("Inserire una password", name: 'insertPassword');

  String get newPassword => Intl.message("Nuova Password", name: 'newPassword');

  String get actualPassword =>
      Intl.message("Password attuale", name: 'actualPassword');

  String get reconnect => Intl.message("Riconnettiti", name: 'reconnect');

  String get valueSign => Intl.message(" €", name: 'valueSign');

  String get avaibleBalance =>
      Intl.message('Saldo disponibile', name: 'avaibleBalance');

  String get remainVouchers =>
      Intl.message('Voucher rimasti', name: 'remainVouchers');

  String get settings => Intl.message("Impostazioni", name: 'settings');

  String get showProfile =>
      Intl.message("Visualizza profilo", name: 'showProfile');

  String get passwordChange =>
      Intl.message("Cambia Password", name: 'passwordChange');

  String get insertInvitationCode =>
      Intl.message('Inserire il codice di invito',
          name: 'insertInvitationCode');

  String get researchRange =>
      Intl.message(" km (Raggio di ricerca)", name: 'researchRange');

  String get insertResearchRange =>
      Intl.message("Inserire un raggio di ricerca",
          name: 'insertResearchRange');

  String get researchRangeMoreThanZero =>
      Intl.message("Inserire un raggio di ricerca\nmaggiore di zero",
          name: 'researchRangeMoreThanZero');

  String get kM => Intl.message(" km", name: 'kM');

  String get allowLocalization => Intl.message(
      "È necessario autorizzare la localizzazione per visualizzare la lista degli affiliati nei paraggi",
      name: 'allowLocalization');

  String get openMap => Intl.message("Mappa", name: 'openMap');

  String get camera => Intl.message("Camera", name: 'camera');

  String get answerNo => Intl.message("No", name: 'answerNo');

  String get answerYes => Intl.message("Si", name: 'answerYes');

  String get allowPhoneCamera => Intl.message(
      "È necessario autorizzare l'uso della fotocamera per usufruire di questo servizio",
      name: 'allowPhoneCamera');

  String get acceptTerms =>
      Intl.message('Per proseguire devi accettare i termini',
          name: 'acceptTerms');

  String get exportHistory =>
      Intl.message('Esporta Storico', name: 'exportHistory');

  String get save => Intl.message("Salva", name: 'save');

  String get voucherAccredit =>
      Intl.message('Accredito di buoni', name: 'voucherAccredit');

  String get reciveVoucherFrom =>
      Intl.message('Ricezione buoni da ', name: 'reciveVoucherFrom');

  String get redeemVoucher =>
      Intl.message('Riscatto buoni', name: 'redeemVoucher');

  String get voucherTransferTo =>
      Intl.message('Trasferimento di buoni verso ', name: 'voucherTransferTo');

  String get genericTransaction =>
      Intl.message('Transazione generica', name: 'genericTransaction');

  String get transactionNumber =>
      Intl.message("Transazione n°", name: 'transactionNumber');

  String get selectedVoucher =>
      Intl.message('Buoni selezionati', name: 'selectedVoucher');

  String get recipient =>
      Intl.message('Affiliato destinatario', name: 'recipient');

  String get recipientSender =>
      Intl.message('Beneficiario mittente', name: 'recipientSender');

  String get causal => Intl.message('Causale', name: 'causal');

  String get noTransactionToExport =>
      Intl.message('Non ci sono transazioni da esportare',
          name: 'noTransactionToExport');

  String get totalSelected =>
      Intl.message("Totale selezionato", name: 'totalSelected');

  String get selectQuantity =>
      Intl.message("Seleziona la quantità", name: 'selectQuantity');

  String get orderSummary =>
      Intl.message("Riepilogo Ordine", name: 'orderSummary');

  String get selectAtLeastOneVoucher =>
      Intl.message('Selezionare almeno un buono',
          name: 'selectAtLeastOneVoucher');

  String get voucherTransferComplete =>
      Intl.message('Trasferimento voucher completato',
          name: 'voucherTransferComplete');

  String get voucherTransferError =>
      Intl.message('Voucher Scaduto. Errore nel trasferimento voucher ',
          name: 'voucherTransferError');

  String get forgotThe =>
      Intl.message('Hai dimenticato la ', name: 'forgotThe');

  String get cash => Intl.message("Cassa ", name: 'cash');

  String get cashNumber => Intl.message("Numero cassa", name: 'cashNumber');

  String get noQrCodeYet =>
      Intl.message("Non ci sono ancora QRcode", name: 'noQrCodeYet');

  String get createNewQrCode =>
      Intl.message("Crea nuovo", name: 'createNewQrCode');

  String get newQrCode => Intl.message("Nuovo QR Code", name: 'newQrCode');

  String get qrCodeDeleted =>
      Intl.message("Il QR code è stato eliminato.", name: 'qrCodeDeleted');

  String get qrCodeCash => Intl.message('QR code cassa ', name: 'qrCodeCash');

  String get insertANumber =>
      Intl.message("Inserisci un numero", name: 'insertANumber');

  String get delete => Intl.message("Elimina", name: 'delete');

  String get history => Intl.message('Storico', name: 'history');

  String get completed => Intl.message('Completato', name: 'completed');

  String get passwordResetError => Intl.message(
      'Si è verificato un errore,\ncontrollare che il link sia valido.',
      name: 'passwordResetError');

  String get logoutSuccesful =>
      Intl.message("Il logout è stato effettuato correttamente",
          name: 'logoutSuccesful');

  String get noTransactionsFound =>
      Intl.message('Non sono state trovate transazioni in questo intervallo',
          name: 'noTransactionsFound');

  String get errorNoDetails =>
      Intl.message('Non è stato possibile recuperare i dettagli.',
          name: 'errorNoDetails');

  String get userNotActive =>
      Intl.message('Utente ancora non attivato', name: 'userNotActive');

  String get imageTooLarge => Intl.message(
      'L\'immagine inserita è troppo grande,\ndimensione massima consentita: ',
      name: 'imageTooLarge');

  String get existingQrCode => Intl.message(
      'Esiste già una cassa con questo numero,\nper favore selezionare un altro numero',
      name: 'existingQrCode');

  String get nonExistingQrCode =>
      Intl.message('Il QR code non è più disponibile.',
          name: 'nonExistingQrCode');

  String get mailSent => Intl.message(
      'Ti abbiamo inoltrato una mail con la procedura di recupero password.',
      name: 'mailSent');

  String get passwordRestored =>
      Intl.message('Password ripristinata!', name: 'passwordRestored');

  String get fingerPrintSet =>
      Intl.message("L'accesso con impronta digitale è stato impostato",
          name: "fingerPrintSet");

  String get touchSensorForAuth =>
      Intl.message('Tocca il sensore per autenticarti',
          name: 'touchSensorForAuth');

  String get noBiometricsOnDevice =>
      Intl.message("Su questo dispositivo non è presente un lettore biometrico",
          name: "noBiometricsOnDevice");

  String get transactionReceived =>
      Intl.message("Hai ricevuto una nuova transazione",
          name: "transactionReceived");

  String get received =>
      Intl.message("Hai ricevuto ",
          name: "received");

  String get ofString =>
      Intl.message(" di ",
          name: "ofString");

  String get transactionsNotification =>
      Intl.message("Notifiche transazioni",
          name: "transactionsNotification");

  String get from =>
      Intl.message(" da ",
          name: "from");

  String get openApp =>
      Intl.message("Apri l'applicazione per i dettagli",
          name: "openApp");



}
