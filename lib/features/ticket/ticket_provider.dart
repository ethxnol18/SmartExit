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
    if (code.trim().length < 4) return false; 
    
    // Mock deriving the entry point from the code metadata
    state = TicketState(
      ticketCode: code.trim(),
      entryPoint: "Mlolongo Entry Gate 2",
    );
    return true;
  }
}

final ticketProvider = StateNotifierProvider<TicketNotifier, TicketState>((ref) {
  return TicketNotifier();
});
