import 'package:flutter_riverpod/flutter_riverpod.dart';

class TicketState {
  final String? ticketCode;
  final String? entryPoint;

  TicketState({this.ticketCode, this.entryPoint});
}

class TicketNotifier extends StateNotifier<TicketState> {
  TicketNotifier() : super(TicketState());

  bool validateAndSetTicket(String code) {
    // Basic mock validation logic
    final cleanCode = code.trim();
    if (cleanCode.length < 4) return false; 
    
    final List<String> allStations = [
      'Mlolongo', 'Athi River', 'Syokimau', 'SGR', 'JKIA', 
      'Cabanas', 'Eastern Bypass', 'Capital Centre', 
      'Haile Selassie', 'Museum Hill', 'Westlands', 'Rironi'
    ];

    String generatedEntry = "Unknown";
    
    // Deterministic mappings based on user prompt
    if (cleanCode == "123456") {
      generatedEntry = "Mlolongo";
    } else if (cleanCode == "654321") {
      generatedEntry = "JKIA";
    } else {
      // Create a deterministic hash from the ticket string
      int pseudoHash = 0;
      for (int i = 0; i < cleanCode.length; i++) {
        pseudoHash += cleanCode.codeUnitAt(i);
      }
      generatedEntry = allStations[pseudoHash % allStations.length];
    }
    
    // Mock deriving the entry point from the code metadata
    state = TicketState(
      ticketCode: cleanCode,
      entryPoint: generatedEntry,
    );
    return true;
  }
}

final ticketProvider = StateNotifierProvider<TicketNotifier, TicketState>((ref) {
  return TicketNotifier();
});
