import 'package:ferry/ferry.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GQLClient {
  GQLClient(this._client);
  final Client _client;

  // ── One-shot query / mutation (await-able) ────────────────────
  Future<OperationResponse<TData, TVars>> run<TData, TVars>(
    OperationRequest<TData, TVars> request,
  ) =>
      _client
          .request(request)
          .firstWhere((OperationResponse<TData, TVars> res) => !res.loading);

  // ── Reactive stream (cache + network, subscriptions) ─────────
  Stream<OperationResponse<TData, TVars>> watch<TData, TVars>(
    OperationRequest<TData, TVars> request,
  ) =>
      _client.request(request);

  // ── Optimistic / manual cache write ──────────────────────────
  void writeToCache<TData, TVars>(
    OperationRequest<TData, TVars> request,
    TData data,
  ) =>
      _client.cache.writeQuery(request, data);
}
