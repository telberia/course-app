import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'dart:convert'; // Added for jsonDecode
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'debug_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
 
  final List<Map<String, dynamic>> lessons = [
    {
      'name': 'Lesson 1',
      'pdf': 'App/Lektion_1/Lektion_1.pdf',
      'audio': [
        'App/Lektion_1/Tab 1_1 - Grußformeln und Befinden - informell.mp3',
        'App/Lektion_1/Tab 1_2 - Grußformeln und Befinden - formell.mp3',
        'App/Lektion_1/Tab 1_3 - Vorstellung - informell.mp3',
        'App/Lektion_1/Tab 1_4 - Vorstellung - formell.mp3',
        'App/Lektion_1/Tab 1_5 - Vorstellung - Alternative.mp3',
        'App/Lektion_1/Tab 1_8 - Ergänzung zum Dialog.mp3',
        'App/Lektion_1/Audio_E1_1.mp3',
        'App/Lektion_1/audio_1_6.mp3',
        'App/Lektion_1/audio_1_7.mp3',
      ],
    },
    {
      'name': 'Lesson 2',
      'pdf': 'App/Lektion_2/vt1_eBook_Lektion_2.pdf',
      'audio': [
        'App/Lektion_2/Audio 2_12 - Text - Ich bin Studentin.mp3',
        'App/Lektion_2/Audio E2_1.mp3',
        'App/Lektion_2/audio_2_11.mp3',
        'App/Lektion_2/Tab 2_1 - Regionale Begrüßungen - ugs.mp3',
        'App/Lektion_2/Tab 2_10 - Elliptische Gegenfrage - informell und formell.mp3',
        'App/Lektion_2/Tab 2_13 - Verabschiedungen.mp3',
        'App/Lektion_2/Tab 2_2 - Begrüßungen.mp3',
        'App/Lektion_2/Tab 2_3 - Alter und Hobbys - informell.mp3',
        'App/Lektion_2/Tab 2_4 - Alter und Hobbys - formell.mp3',
        'App/Lektion_2/Tab 2_5 - Arbeit - informell.mp3',
        'App/Lektion_2/Tab 2_6 - Arbeit - formell.mp3',
        'App/Lektion_2/Tab 2_7 - Studium - informell und formell.mp3',
        'App/Lektion_2/Tab 2_8 - Studium - Verneinung_arbeiten und studieren.mp3',
        'App/Lektion_2/Tab 2_9 - Berufliche Situation - Alternativen.mp3',
      ],
    },
    {
      'name': 'Lesson 3',
      'pdf': 'App/Lektion_3/vt1_eBook_Lektion_3.pdf',
      'audio': [
        'App/Lektion_3/Audio 3_7 - Text - Noch mal, bitte.mp3',
        'App/Lektion_3/Tab 3_1 - Sprachkenntnisse.mp3',
        'App/Lektion_3/Tab 3_2 - Sprachkenntnisse - Variationen.mp3',
        'App/Lektion_3/Tab 3_3 - Verständnisprobleme.mp3',
        'App/Lektion_3/Tab 3_4 - um Wiederholung bitten.mp3',
        'App/Lektion_3/Tab 3_5 - Entschuldigung als Ansprache.mp3',
        'App/Lektion_3/Tab 3_6 - Entschuldigung - Variationen.mp3',
      ],
    },
    {
      'name': 'Lesson 4',
      'pdf': 'App/Lektion_4/vt1_eBook_Lektion_4.pdf',
      'audio': [
        'App/Lektion_4/Audio 4_16 - Text - Kannst du mir kurz helfen.mp3',
        'App/Lektion_4/Audio 4_17 - Text - Wie kann ich Ihnen helfen.mp3',
        'App/Lektion_4/Tab 4_1 - ja, nein, vielleicht.mp3',
        'App/Lektion_4/Tab 4_10 - Orientierung und Verfügbarkeit.mp3',
        'App/Lektion_4/Tab 4_11 - Richtungsangaben.mp3',
        'App/Lektion_4/Tab 4_12 - Ortsangaben.mp3',
        'App/Lektion_4/Tab 4_13 - Preis.mp3',
        'App/Lektion_4/Tab 4_14 - kurze Bestätigung.mp3',
        'App/Lektion_4/Tab 4_15 - kurze Bestätigung ugs.mp3',
        'App/Lektion_4/Tab 4_2 - Bestätigung und Verneinung.mp3',
        'App/Lektion_4/Tab 4_3 - danke, bitte, gerne.mp3',
        'App/Lektion_4/Tab 4_4 - danke - Variationen.mp3',
        'App/Lektion_4/Tab 4_5 - bitte und gerne - Variationen.mp3',
        'App/Lektion_4/Tab 4_6 - Fahrkarte und Identifikation.mp3',
        'App/Lektion_4/Tab 4_7 - warten und folgen.mp3',
        'App/Lektion_4/Tab 4_8 - Hilfe anbieten.mp3',
        'App/Lektion_4/Tab 4_9 - um Hilfe bitten.mp3',
      ],
    },
    {
      'name': 'Lesson 5',
      'pdf': 'App/Lektion_5/vt1_eBook_Lektion_5.pdf',
      'audio': [
        'App/Lektion_5/Audio 5_21 - Text - Einen Tisch für zwei Personen bitte.mp3',
        'App/Lektion_5/Audio 5_22 - Text - Was darf ich Ihnen bringen.mp3',
        'App/Lektion_5/Audio 5_23 - Text - Die Rechnung bitte.mp3',
        'App/Lektion_5/Audio W5_1.mp3',
        'App/Lektion_5/Tab 5_1 - Nach einem Tisch fragen.mp3',
        'App/Lektion_5/Tab 5_10 - Wasserarten.mp3',
        'App/Lektion_5/Tab 5_11 - Alkoholische Getränke.mp3',
        'App/Lektion_5/Tab 5_12 - Bezahlprozess.mp3',
        'App/Lektion_5/Tab 5_13 - Trinkgeld geben.mp3',
        'App/Lektion_5/Tab 5_14 - Quittung.mp3',
        'App/Lektion_5/Tab 5_15 - sich höflich bedanken.mp3',
        'App/Lektion_5/Tab 5_16 - Toilette.mp3',
        'App/Lektion_5/Tab 5_17 - sich entschuldigen.mp3',
        'App/Lektion_5/Tab 5_18 - telefonisch Essen bestellen.mp3',
        'App/Lektion_5/Tab 5_19 - telefonisch Essen bestellen - Adresse angeben.mp3',
        'App/Lektion_5/Tab 5_20 - telefonisch Essen bestellen - Rückfragen und Hinweise.mp3',
        'App/Lektion_5/Tab 5_2 - Tischreservierung.mp3',
        'App/Lektion_5/Tab 5_3 - Bestellung aufnehmen.mp3',
        'App/Lektion_5/Tab 5_4 - um ewas bitten und bestellen.mp3',
        'App/Lektion_5/Tab 5_5 - bestellen-Alternative.mp3',
        'App/Lektion_5/Tab 5_6 - bestellen mit nonverbaler Ergänzung.mp3',
        'App/Lektion_5/Tab 5_7 - weitere Bestellphrasen.mp3',
        'App/Lektion_5/Tab 5_8 - Spezifikationen - vor Ort oder zum Mitnehmen.mp3',
        'App/Lektion_5/Tab 5_9 - Spezifikationen - Getränkezusätze.mp3',
      ],
    },
    {
      'name': 'Lesson 6',
      'pdf': 'App/Lektion_6/vt1_eBook_Lektion_6.pdf',
      'audio': [
        'App/Lektion_6/Audio 6_13 - Text - Wohin möchten Sie fahren.mp3',
        'App/Lektion_6/Audio 6_14 - Text - Wann kommt der nächste Bus.mp3',
        'App/Lektion_6/Audio W6_1.mp3',
        'App/Lektion_6/Tab 6_1 - Verkehrsmittel - Ich nehme.mp3',
        'App/Lektion_6/Tab 6_10 - Verspätung und Ausfall.mp3',
        'App/Lektion_6/Tab 6_11 - Ankunftszeit und Verspätung.mp3',
        'App/Lektion_6/Tab 6_12 - Zimmer buchen.mp3',
        'App/Lektion_6/Tab 6_2 - Verkehrsmittel - Ich fahre mit.mp3',
        'App/Lektion_6/Tab 6_3 - Verkehrsmittel - zu Fuß und mit dem Flugzeug.mp3',
        'App/Lektion_6/Tab 6_4 - Orientierung und Ticketkauf.mp3',
        'App/Lektion_6/Tab 6_5 - richtiges Verkehrsmittel finden.mp3',
        'App/Lektion_6/Tab 6_6 - Ziel angeben.mp3',
        'App/Lektion_6/Tab 6_7 - um Auskunft bitten.mp3',
        'App/Lektion_6/Tab 6_8 - Verbindung und Umstieg.mp3',
        'App/Lektion_6/Tab 6_9 - Abfahrt und Ankunft.mp3',
      ],
    },
    {
      'name': 'Lesson 7',
      'pdf': 'App/Lektion_7/vt1_eBook_Lektion_7.pdf',
      'audio': [
        'App/Lektion_7/Audio 7_10 - Text - Sie sind auch nicht von hier, oder.mp3',
        'App/Lektion_7/Tab 7_1 - Diskursmarker.mp3',
        'App/Lektion_7/Tab 7_2 - Pausenfüller.mp3',
        'App/Lektion_7/Tab 7_3 - Verständnissicherung.mp3',
        'App/Lektion_7/Tab 7_4 - Rückversicherung.mp3',
        'App/Lektion_7/Tab 7_5 - Unwissenheit ausdrücken.mp3',
        'App/Lektion_7/Tab 7_6 - Unwissenheit ausdrücken - Alternativen.mp3',
        'App/Lektion_7/Tab 7_7 - Bestätigungsfragen.mp3',
        'App/Lektion_7/Tab 7_8 - Bestätigung und Zustimmung.mp3',
        'App/Lektion_7/Tab 7_9 - Verneinung und Korrektur.mp3',
      ],
    },
    {
      'name': 'Lesson 8',
      'pdf': 'App/Lektion_8/vt1_eBook_Lektion_8.pdf',
      'audio': [
        'App/Lektion_8/Audio 8_21 - Text - Wo ist das Fundbüro.mp3',
        'App/Lektion_8/Audio 8_22 - Text - Meine Sachen sind weg.mp3',
        'App/Lektion_8/Tab 8_1 - Warnhinweise.mp3',
        'App/Lektion_8/Tab 8_10 - Handy aufladen.mp3',
        'App/Lektion_8/Tab 8_11 - Telefon benutzen.mp3',
        'App/Lektion_8/Tab 8_12 - Akku leer.mp3',
        'App/Lektion_8/Tab 8_13 - Verlust melden.mp3',
        'App/Lektion_8/Tab 8_14 - Verlust melden - Alternative 1.mp3',
        'App/Lektion_8/Tab 8_15 - Verlust melden - Alternative 2.mp3',
        'App/Lektion_8/Tab 8_16 - Diebstahl melden.mp3',
        'App/Lektion_8/Tab 8_17 - Überforderung ausdrücken.mp3',
        'App/Lektion_8/Tab 8_18 - Notruf veranlassen.mp3',
        'App/Lektion_8/Tab 8_19 - Notrufnummern im DACH-Raum.mp3',
        'App/Lektion_8/Tab 8_2 - Warnrufe.mp3',
        'App/Lektion_8/Tab 8_20 - Euronotrufnummer.mp3',
        'App/Lektion_8/Tab 8_3 - Hilfe rufen.mp3',
        'App/Lektion_8/Tab 8_4 - Hilfe anbieten.mp3',
        'App/Lektion_8/Tab 8_5 - auf Hilfsangebote reagieren.mp3',
        'App/Lektion_8/Tab 8_6 - um Auskunft bitten.mp3',
        'App/Lektion_8/Tab 8_7 - um Auskunft bitten - Gibt es hier.mp3',
        'App/Lektion_8/Tab 8_8 - keine Auskunft.mp3',
        'App/Lektion_8/Tab 8_9 - auf keine Auskunft reagieren.mp3',
      ],
    },
    {
      'name': 'Lesson 9',
      'pdf': 'App/Lektion_9/vt1_eBook_Lektion_9.pdf',
      'audio': [
        'App/Lektion_9/Audio 9_9 - Text - Ihre Adresse bitte.mp3',
        'App/Lektion_9/Tab 9_1 - Wohnadresse und Kontaktdaten.mp3',
        'App/Lektion_9/Tab 9_2 - Wohnadresse und Kontaktdaten - Alternative.mp3',
        'App/Lektion_9/Tab 9_3 - Geburtsdatum.mp3',
        'App/Lektion_9/Tab 9_4 - Geburtstag.mp3',
        'App/Lektion_9/Tab 9_5 - Familienstand.mp3',
        'App/Lektion_9/Tab 9_6 - Kinder.mp3',
        'App/Lektion_9/Tab 9_7 - Geschwister.mp3',
        'App/Lektion_9/Tab 9_8 - Haustiere.mp3',
      ],
    },
    {
      'name': 'Lesson 10',
      'pdf': 'App/Lektion_10/vt1_eBook_Lektion_10.pdf',
      'audio': [
        'App/Lektion_10/Audio W1.mp3',
      ],
    },
    {
      'name': 'Lesson 11',
      'pdf': 'App/Lektion_11/vt1_eBook_Lektion_11.pdf',
      'audio': [
        'App/Lektion_11/Audio 11_10 - Text - Wie lange bist du schon hier.mp3',
        'App/Lektion_11/Tab 11_1 - Aufenthaltsdauer.mp3',
        'App/Lektion_11/Tab 11_2 - Aufenthaltsdauer - regionale Variante.mp3',
        'App/Lektion_11/Tab 11_3 - Geplanter Aufenthalt.mp3',
        'App/Lektion_11/Tab 11_4 - vergangene Reisen.mp3',
        'App/Lektion_11/Tab 11_5 - besuchte Orte.mp3',
        'App/Lektion_11/Tab 11_6 - Grund des Aufenthalts erfragen.mp3',
        'App/Lektion_11/Tab 11_7 - Grund des Aufenthalts angeben.mp3',
        'App/Lektion_11/Tab 11_8 - Grund des Aufenthalts angeben und erfragen - Alternative.mp3',
        'App/Lektion_11/Tab 11_9 - Grund des Aufenthalts - verkürzt.mp3',
      ],
    },
    {
      'name': 'Lesson 12',
      'pdf': 'App/Lektion_12/vt1_eBook_Lektion_12.pdf',
      'audio': [
        'App/Lektion_12/Audio 12_6 - Text - Wo waren Sie schon überall.mp3',
        'App/Lektion_12/Audio 12_7 - Text - Du bist neu hier, ja.mp3',
        'App/Lektion_12/Tab 12_1 - Meinung zum Aufenthalt.mp3',
        'App/Lektion_12/Tab 12_2 - Gefallen ausdrücken.mp3',
        'App/Lektion_12/Tab 12_3 - über das Deutschlernen sprechen.mp3',
        'App/Lektion_12/Tab 12_4 - über Deutschkenntnisse sprechen.mp3',
        'App/Lektion_12/Tab 12_5 - über besuchte Orte sprechen.mp3',
      ],
    },
    {
      'name': 'Lesson 13',
      'pdf': 'App/Lektion_13/vt1_eBook_Lektion_13.pdf',
      'audio': [
        'App/Lektion_13/Audio 13_6 - Text - Was machst du gerne in deiner Freizeit.mp3',
        'App/Lektion_13/Tab 13_1 Hobbys nennen - Ich gehe gerne.mp3',
        'App/Lektion_13/Tab 13_2 Hobbys nennen - Ich spiele gerne.mp3',
        'App/Lektion_13/Tab 13_3 Hobbys nennen - Ich mache gerne.mp3',
        'App/Lektion_13/Tab 13_4 Hobbys nennen - Ich verbringe gerne Zeit.mp3',
        'App/Lektion_13/Tab 13_5 nach Hobbys fragen.mp3',
      ],
    },
    {
      'name': 'Lesson 14',
      'pdf': 'App/Lektion_14/vt1_eBook_Lektion_14.pdf',
      'audio': [
        'App/Lektion_14/Audio 14_14 - Text - Siehst du gerne Filme.mp3',
        'App/Lektion_14/Audio 14_15 - Text - Das Restaurant heißt Roter Hummer.mp3',
        'App/Lektion_14/Tab 14_1 - Vorlieben ausdrücken - Filme und Serien.mp3',
        'App/Lektion_14/Tab 14_10 - Gefallen ausdrücken mit Adjektiven ugs.mp3',
        'App/Lektion_14/Tab 14_11 - Reaktion auf Aussagen und Vorschläge.mp3',
        'App/Lektion_14/Tab 14_12 - Missfallen und Unzufriedenheit ausdrücken.mp3',
        'App/Lektion_14/Tab 14_13 - Graduierung von Meinungen.mp3',
        'App/Lektion_14/Tab 14_2 - Vorlieben ausdrücken - Essen.mp3',
        'App/Lektion_14/Tab 14_3 - Ernährungsweise angeben.mp3',
        'App/Lektion_14/Tab 14_4 - Lieblingsdinge nennen - Bücher.mp3',
        'App/Lektion_14/Tab 14_5 - Lieblingsdinge nennen - Essen.mp3',
        'App/Lektion_14/Tab 14_6 - Meinung ausdrücken mit gefallen.mp3',
        'App/Lektion_14/Tab 14_7 - Meinung ausdrücken mit schmecken.mp3',
        'App/Lektion_14/Tab 14_8 - Gefallen ausdrücken.mp3',
        'App/Lektion_14/Tab 14_9 - Gefallen ausdrücken mit Adjektiven.mp3',
      ],
    },
    {
      'name': 'Lesson 15',
      'pdf': 'App/Lektion_15/vt1_eBook_Lektion_15.pdf',
      'audio': [
        'App/Lektion_15/Audio 15_11 - Text - Ich koche fast nie.mp3',
        'App/Lektion_15/Audio 15_12 - Text - Ein-bis zweimal in der Woche.mp3',
        'App/Lektion_15/Tab 15_1 - Aktionen einleiten.mp3',
        'App/Lektion_15/Tab 15_10 - Aktionen einleiten und Aussagen kommentieren.mp3',
        'App/Lektion_15/Tab 15_2 - Antworten zwischen Ja und Nein.mp3',
        'App/Lektion_15/Tab 15_3 - Häufigkeit und Regelmäßigkeit.mp3',
        'App/Lektion_15/Tab 15_4 - Gegenfragen bei Überraschung.mp3',
        'App/Lektion_15/Tab 15_5 - Sätze zur Beruhigung.mp3',
        'App/Lektion_15/Tab 15_6 - Emotionale Bewertung.mp3',
        'App/Lektion_15/Tab 15_7 - Gleichgültigkeit ausdrücken.mp3',
        'App/Lektion_15/Tab 15_8 - Gleichgültigkeit ausdrücken - Alternativen.mp3',
        'App/Lektion_15/Tab 15_9 - Floskeln und Redewendungen.mp3',
      ],
    },
    {
      'name': 'Lesson 16',
      'pdf': 'App/Lektion_16/vt1_eBook_Lektion_16.pdf',
      'audio': [
        'App/Lektion_16/Audio 16_10 - Text - Hast du am Sonntag Zeit.mp3',
        'App/Lektion_16/Audio 16_11 - Text - Was machst du am Wochenende.mp3',
        'App/Lektion_16/Tab 16_1 - Aktivitäten vorschlagen - Hast du Lust.mp3',
        'App/Lektion_16/Tab 16_2 - Aktivitäten vorschlagen - Wollen wir.mp3',
        'App/Lektion_16/Tab 16_3 - Aktivitäten vorschlagen - Gehen wir.mp3',
        'App/Lektion_16/Tab 16_4 - Verfügbarkeit und Uhrzeit nennen und erfragen.mp3',
        'App/Lektion_16/Tab 16_5 - Treffpunkt vorschlagen und erfragen.mp3',
        'App/Lektion_16/Tab 16_6 - Treffen zusagen,verschieben und absagen.mp3',
        'App/Lektion_16/Tab 16_7 - über das Wetter sprechen.mp3',
        'App/Lektion_16/Tab 16_8 - Wetterphänomene nennen.mp3',
        'App/Lektion_16/Tab 16_9 - Angaben zur Temperatur.mp3',
      ],
    },
    {
      'name': 'Lesson 17',
      'pdf': 'App/Lektion_17/vt1_eBook_Lektion_17.pdf',
      'audio': [
        'App/Lektion_17/Audio 17_14 - Text - Wie ist der Name.mp3',
        'App/Lektion_17/Audio 17_15 - Text - Was machst du am Samstag.mp3',
        'App/Lektion_17/Tab 17_1 - Termine vereinbaren.mp3',
        'App/Lektion_17/Tab 17_10 - Uhrzeit nennen - 24-Stunden-System.mp3',
        'App/Lektion_17/Tab 17_11 - Uhrzeit mit Tageszeit nennen.mp3',
        'App/Lektion_17/Tab 17_12 - Zeitpunkt erfragen und angeben.mp3',
        'App/Lektion_17/Tab 17_13 - Zeiteinheiten - Sekunde, Minute, Stunde.mp3',
        'App/Lektion_17/Tab 17_2 - Terminvorschlag zusagen und ablehnen.mp3',
        'App/Lektion_17/Tab 17_3 - Wochenabschnitte.mp3',
        'App/Lektion_17/Tab 17_4 - Wochentage.mp3',
        'App/Lektion_17/Tab 17_5 - Tageszeiten.mp3',
        'App/Lektion_17/Tab 17_6 - Tageszeiten als Adverbien.mp3',
        'App/Lektion_17/Tab 17_7 - Wochentage als Adverbien.mp3',
        'App/Lektion_17/Tab 17_8 - Uhrzeit erfragen und angeben.mp3',
        'App/Lektion_17/Tab 17_9 - Uhrzeit nennen.mp3',
      ],
    },
    {
      'name': 'Lesson 18',
      'pdf': 'App/Lektion_18/vt1_eBook_Lektion_18.pdf',
      'audio': [
        'App/Lektion_18/Audio 18_10 - Text - Zahnarztpraxis Weiß, Sie sprechen mit Frau Weber.mp3',
        'App/Lektion_18/Tab 18_1 - Telefonieren_Begrüßung.mp3',
        'App/Lektion_18/Tab 18_2 - Telefonieren_Begrüßungsformeln.mp3',
        'App/Lektion_18/Tab 18_3 - Telefonieren_Verabschiedung.mp3',
        'App/Lektion_18/Tab 18_4 - Telefonieren_Dank und Abschluss.mp3',
        'App/Lektion_18/Tab 18_5 - Formeller Schriftverkehr - Begrüßung.mp3',
        'App/Lektion_18/Tab 18_6 - Formeller Schriftverkehr - Verabschiedung.mp3',
        'App/Lektion_18/Tab 18_7 - Informeller Schriftverkehr - Begrüßung.mp3',
        'App/Lektion_18/Tab 18_8 - Informeller Schriftverkehr - Verabschiedung.mp3',
        'App/Lektion_18/Tab 18_9 - Abkürzungen in der geschriebenen Sprache.mp3',
      ],
    },
    {
      'name': 'Lesson 19',
      'pdf': 'App/Lektion_19/vt1_eBook_Lektion_19.pdf',
      'audio': [
        'App/Lektion_19/Audio 19_11 - Text - Ich habe Fieber und Husten.mp3',
        'App/Lektion_19/Tab 19_1 - Allgemeines Befinden erfragen und ausdrücken.mp3',
        'App/Lektion_19/Tab 19_10 - Genesungswünsche.mp3',
        'App/Lektion_19/Tab 19_2 - Allgemeines Befinden - differenzierte Angabe.mp3',
        'App/Lektion_19/Tab 19_3 - Beschwerden erfragen.mp3',
        'App/Lektion_19/Tab 19_4 - Psychisches Befinden ausdrücken.mp3',
        'App/Lektion_19/Tab 19_5 - Physisches Befinden ausdrücken.mp3',
        'App/Lektion_19/Tab 19_6 - Krankheit und Beschwerden nennen.mp3',
        'App/Lektion_19/Tab 19_7 - Beschwerden benennen - Ich habe -schmerzen.mp3',
        'App/Lektion_19/Tab 19_8 - Beschwerden benennen - tut, tun weh.mp3',
        'App/Lektion_19/Tab 19_9 - Krankheiten und Symptome benennen.mp3',
      ],
    },
    {
      'name': 'Lesson 20',
      'pdf': 'App/Lektion_20/vt1_eBook_Lektion_20.pdf',
      'audio': [
        'App/Lektion_20/Audio 20_10 - Text - Komm rein.mp3',
        'App/Lektion_20/Audio 20_11 - Text - Wie gefällt Ihnen die Wohnung.mp3',
        'App/Lektion_20/Tab 20_1 - Wohnsituation beschreiben.mp3',
        'App/Lektion_20/Tab 20_2 - vorübergehende Wohnsituation beschreiben.mp3',
        'App/Lektion_20/Tab 20_3 - Wohnsituation beschreiben_Wir-Form.mp3',
        'App/Lektion_20/Tab 20_4 - Details zur Wohnsituation angeben.mp3',
        'App/Lektion_20/Tab 20_5 - Hausarbeiten nennen.mp3',
        'App/Lektion_20/Tab 20_6 - Probleme im Haushalt melden.mp3',
        'App/Lektion_20/Tab 20_7 - Besuch empfangen.mp3',
        'App/Lektion_20/Tab 20_8 - Besuch bewirten.mp3',
        'App/Lektion_20/Tab 20_9 - Wohnungsführung.mp3',
      ],
    },
    {
      'name': 'Anhang Referenzlisten',
      'pdf': 'App/Anhang_Referenzlisten/vt1_eBook_Anhang.pdf',
      'audio': [
        'App/Anhang_Referenzlisten/Ref_1 - Alphabet und Buchstabiertafel.mp3',
        'App/Anhang_Referenzlisten/Ref_2 - Ländernamen.mp3',
        'App/Anhang_Referenzlisten/Ref_3 - Städtenamen.mp3',
        'App/Anhang_Referenzlisten/Ref_4 - Berufsbezeichnungen.mp3',
        'App/Anhang_Referenzlisten/Ref_5 - Kardinalzahlen.mp3',
        'App/Anhang_Referenzlisten/Ref_6 - Ordinalzahlen.mp3',
        'App/Anhang_Referenzlisten/Ref_7 - Monatsnamen.mp3',
        'App/Anhang_Referenzlisten/Ref_8 - Farben.mp3',
      ],
    },
    {
      'name': 'Losungen',
      'pdf': 'App/Losungen/vt1_eBook_Losungen.pdf',
      'audio': [],
    },
    {
      'name': 'Titelei und IHV',
      'pdf': 'App/Titelei und IHV/vt1_eBook_Titelei_IHV.pdf',
      'audio': [],
    },
    {
      'name': 'Wiederholung und Sprechtraining',
      'pdf': 'App/Wiederholung_und_Sprechtraining/vt1_eBook_Wiederholung_und_Sprechtraining.pdf',
      'audio': [
        'App/Wiederholung_und_Sprechtraining/Audio ST01.mp3',
        'App/Wiederholung_und_Sprechtraining/Audio ST02.mp3',
        'App/Wiederholung_und_Sprechtraining/Audio W2.mp3',
      ],
    },
  ];

  void _showUserInfoDialog() {
    final user = Supabase.instance.client.auth.currentUser;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Benutzerinformationen'),
        content: user == null
            ? const Text('Keine Benutzerdaten gefunden')
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('E-Mail: ${user.email}'),
                  Text('Benutzer-ID: ${user.id}'),
                ],
              ),
        actions: [
          TextButton(
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
              if (mounted) {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            child: const Text('Abmelden'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Schließen'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kursliste'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DebugPage()),
              );
            },
            tooltip: 'Debug Info',
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: _showUserInfoDialog,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          final lesson = lessons[index];
          return ListTile(
            title: Text(lesson['name']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LessonDetailPage(
                    lessonName: lesson['name'],
                    pdfPath: lesson['pdf'],
                    audioFiles: List<String>.from(lesson['audio']),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class LessonDetailPage extends StatefulWidget {
  final String lessonName;
  final String pdfPath;
  final List<String> audioFiles;
  const LessonDetailPage({super.key, required this.lessonName, required this.pdfPath, required this.audioFiles});

  @override
  State<LessonDetailPage> createState() => _LessonDetailPageState();
}

class _LessonDetailPageState extends State<LessonDetailPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _audioDuration = Duration.zero;
  Duration _audioPosition = Duration.zero;
  bool _isPlaying = false;
  String? _audioError;
  int? _currentAudioIndex; // Lưu index audio đang phát

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _audioPlayer.onDurationChanged.listen((d) {
        setState(() => _audioDuration = d);
      });
      _audioPlayer.onPositionChanged.listen((p) {
        setState(() => _audioPosition = p);
      });
      _audioPlayer.onPlayerStateChanged.listen((state) {
        setState(() => _isPlaying = state == PlayerState.playing);
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playAudio(String audioPath, int index) async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Audio wird nur auf Mobilgeräten unterstützt')),
      );
    } else {
      try {
        setState(() {
          _audioError = null;
          _currentAudioIndex = index;
        });
        await _audioPlayer.stop();
        await _audioPlayer.play(AssetSource(audioPath));
      } catch (e) {
        setState(() { _audioError = 'Fehler beim Abspielen: $e'; });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Abspielen: $e')),
        );
      }
    }
  }

  void _stopAudio() async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Audio wird nur auf Mobilgeräten unterstützt')),
      );
    } else {
      try {
        await _audioPlayer.stop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Stoppen: $e')),
        );
      }
    }
  }

  String _formatDuration(Duration d) {
    return "${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.lessonName)),
      body: Column(
        children: [
          ListTile(
            title: const Text('PDF anzeigen'),
            subtitle: Text('Pfad: ${widget.pdfPath}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PDFViewPage(pdfAssetPath: widget.pdfPath),
                ),
              );
            },
          ),
          const Divider(),
          const Text('Audiodateien', style: TextStyle(fontWeight: FontWeight.bold)),
          if (_audioError != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _audioError!,
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          Expanded(
            child: widget.audioFiles.isEmpty
                ? const Center(child: Text('Keine Audiodateien'))
                : ListView.builder(
                    itemCount: widget.audioFiles.length,
                    itemBuilder: (context, index) {
                      final audio = widget.audioFiles[index];
                      final audioName = audio.split('/').last;
                      final isCurrent = index == _currentAudioIndex;
                      return ListTile(
                        title: Text(audioName),
                        subtitle: Column(
                          children: [
                            Slider(
                              min: 0,
                              max: _audioDuration.inMilliseconds.toDouble(),
                              value: isCurrent
                                  ? _audioPosition.inMilliseconds.clamp(0, _audioDuration.inMilliseconds).toDouble()
                                  : 0,
                              onChanged: isCurrent
                                  ? (value) async {
                                      final position = Duration(milliseconds: value.toInt());
                                      if (!kIsWeb) {
                                        await _audioPlayer.seek(position);
                                      }
                                    }
                                  : null,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  isCurrent ? _formatDuration(_audioPosition) : '0:00',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                Text(
                                  isCurrent ? _formatDuration(_audioDuration) : '0:00',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.play_arrow),
                              onPressed: () => _playAudio(audio, index),
                              tooltip: 'Abspielen',
                            ),
                            IconButton(
                              icon: const Icon(Icons.stop),
                              onPressed: _stopAudio,
                              tooltip: 'Stopp',
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class PDFViewPage extends StatelessWidget {
  final String pdfAssetPath;
  const PDFViewPage({super.key, required this.pdfAssetPath});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Scaffold(
        appBar: AppBar(title: const Text('PDF anzeigen')),
        body: const Center(child: Text('PDF-Anzeige nur auf Mobilgeräten unterstützt')), 
      );
    } else {
      // Mobile: dùng flutter_pdfview như cũ
      return Scaffold(
        appBar: AppBar(title: const Text('PDF anzeigen')),
        body: FutureBuilder<String>(
          future: _copyAssetToTemp('' + pdfAssetPath),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Fehler:  ${snapshot.error}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Zurück'),
                    ),
                  ],
                ),
              );
            }
            if (!snapshot.hasData) {
              return const Center(child: Text('PDF-Datei nicht gefunden'));
            }
            return PDFView(
              filePath: snapshot.data!,
            );
          },
        ),
      );
    }
  }

  Future<String> _copyAssetToTemp(String assetPath) async {
    try {
      final bytes = await rootBundle.load('assets/' + assetPath);
      final dir = await Directory.systemTemp.createTemp();
      final file = File('${dir.path}/${assetPath.split('/').last}');
      await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
      return file.path;
    } catch (e) {
      throw Exception('Fehler beim Laden der PDF-Datei: $e');
    }
  }
} 