
import 'package:tezster_dart/packages/tzip-16/metadata-interface.dart';

abstract class  MetadataProviderInterface {
    provideMetadata(contractAbstraction, uri, context);
}
abstract class  MetadataEnvelope {
    // uri: string;
    String uri;
    // integrityCheckResult?: boolean;
    bool integrityCheckResult;
    // sha256Hash?: string;
    String sha256hash;
    // metadata: MetadataInterface;
    MetadataInterface metadata;
}