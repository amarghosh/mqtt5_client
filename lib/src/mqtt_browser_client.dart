/*
 * Package : mqtt_browser_client
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 10/05/2020
 * Copyright :  S.Hamblett
 */

part of '../mqtt5_browser_client.dart';

class MqttBrowserClient extends MqttClient {
  /// Initializes a new instance of the MqttServerClient class using the
  /// default Mqtt Port.
  /// The server hostname to connect to
  /// The client identifier to use to connect with
  MqttBrowserClient(
    super.server,
    super.clientIdentifier, {
    this.maxConnectionAttempts = 3,
  });

  /// Initializes a new instance of the MqttServerClient class using
  /// the supplied Mqtt Port.
  /// The server hostname to connect to
  /// The client identifier to use to connect with
  /// The port to use
  MqttBrowserClient.withPort(
    super.server,
    super.clientIdentifier,
    int super.port, {
    this.maxConnectionAttempts = 3,
  }) : super.withPort();

  /// Max connection attempts
  final int maxConnectionAttempts;

  /// Performs a connect to the message broker with an optional
  /// username and password for the purposes of authentication.
  /// If a username and password are supplied these will override
  /// any previously set in a supplied connection message so if you
  /// supply your own connection message and use the authenticateAs method to
  /// set these parameters do not set them again here.
  @override
  Future<MqttConnectionStatus?> connect(
      [String? username, String? password]) async {
    instantiationCorrect = true;
    clientEventBus = events.EventBus();
    clientEventBus
        ?.on<DisconnectOnNoPingResponse>()
        .listen(disconnectOnNoPingResponse);
    connectionHandler = MqttSynchronousBrowserConnectionHandler(
      clientEventBus,
      maxConnectionAttempts: maxConnectionAttempts,
    );
    return await super.connect(username, password);
  }
}
