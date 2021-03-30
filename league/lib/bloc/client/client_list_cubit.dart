import 'package:flutter_bloc/flutter_bloc.dart';
import 'client_list_models.dart';
import 'client_list_repository.dart';
import 'package:league/bloc/client/client_list_state.dart';

class ClientListCubit extends Cubit<ClientListState> {
  ClientListCubit() : super(null);
  void getClientListSection() async {
    final ClientListState clientListState = await getClientList();
    emit(clientListState);
  }

  void setSelectedClientList(ClientList clientList) {
    state.selectedClientList = clientList;
    emit(state);
  }

  List<Client> getSelectedClients() {
    List<Client> selectedClients = new List<Client>();

    selectedClients.addAll(state.clients
        .where((f) => state.selectedClientIds.contains(f.id))
        .toList());

    selectedClients.addAll(state.clients
        .where((f) => state.selectedClientIds.contains(f.id))
        .toList());

    return selectedClients;
  }

  void setSelectedClients(String clientId) {
    var newClientListIds = new List.of(state.selectedClientIds);
    if (newClientListIds.contains(clientId)) {
      newClientListIds.remove(clientId);
    } else {
      newClientListIds.add(clientId);
    }
    state.selectedClientIds = newClientListIds;
    emit(state);
  }
}
