# Context propagation

- **Distributed Tracing** : Distributed tracing is a technique used to track a single request as it travels across multiple services in a distributed (microservices) system. A System across Services.

- **Context** :
  - Context is an object that container the information for the sender and the receiving services. to corelate one signal to another.
  - Ex: In a microservices When gatewayApi called authServices. The gatewayApi includes a trace ID and a span ID. Now authServices use those value to create a new span that belong to the same trace, setting the span from gatewayApi as its parents. This make the full flow of the request across service boundaries.

- **Propagation** :
  - Propagation is the mechanism that moves context between services and process. It serializes or deserializes the context object and provides the relevant information to be propagated from one service to another.
  - Propagation means passing tracing information from one service to another as a request moves through the system.
  - Ex: <version>-<trace-id>-<version>-<trace-id> , 00-2130912730712093710973-01-1209831208309128

- Context carries the trace ID and span ID, and propagation passes this context across services so all spans are connected within the same trace

- **Traces** :
