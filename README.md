# OpenClaw SRE bot

This repository contains the deployment configuration for the OpenClaw SRE bot, showcasing an automated agent capable of managing Kubernetes clusters.

![demo](./docs/img/openclaw-sre-demo.jpg)

## Architecture

The core of this deployment is a containerized environment orchestrated by **supervisord**.

**Container Entrypoint**: `supervisord` manages the lifecycle of the following components:

1.  **Web VNC Server**: Provides visual access to the desktop environment.
2.  **Desktop Environment**: A graphical interface running inside the container, essential for browser-based automation tasks.
3.  **OpenClaw Gateway**: The core agent process that interacts with the environment.

    > The Web VNC and Desktop Environment are based on the [CUA Computer Use Environment](https://github.com/trycua/cua/).

**Logical Layers**:

*   **Upper Layer (Slack Bot)**: The interface for user interaction. Commands are received via Slack.
*   **Core Layer**: The OpenClaw agent running within the desktop environment.
*   **Lower Layer (LiteLLM Gateway)**: An LLM endpoint proxy (based on LiteLLM) that the agent uses for intelligence.

```text
      +-----------------------+
      |      Slack (User)     |
      +-----------+-----------+
                  |
                  v
+------------------------------------------+        +--------------------------+
|          Container (Supervisord)         |        |   Target K8s Clusters    |
|                                          |        |                          |
|  +-------------+      +---------------+  |        |  +--------------------+  |
|  |   Web VNC   | <--> |  Desktop Env  |  |        |  |     Prod Cluster   |  |
|  +------+------+      +-------+-------+  |        |  +--------------------+  |
|         ^                     ^          |        |                          |
|         |                     |          |Operates|  +--------------------+  |
|  (Browser Access)     +-------+-------+  |------->|  |    Stage Cluster   |  |
|                       |    OpenClaw   |  |        |  +--------------------+  |
|                       |    Gateway    |  |        |                          |
|                       +-------+-------+  |        +--------------------------+
|                               |          |
+-------------------------------+----------+
                                |
                                v
                     +--------------------+
                     |   LiteLLM Gateway  |
                     +--------------------+
```

## Installation

### Prerequisites

*   Helm 3.x installed
*   Kubernetes cluster (and context configured)

### Configuration

Before installing, you need to configure the `openclaw` settings in `deploy/chart/values.yaml`. Specifically, fill in the necessary tokens and API keys:

```yaml
openclaw:
  gatewayToken: "YOUR_GATEWAY_TOKEN"
  primaryModel: "kaito/gpt-5.1" # or your preferred model
  kaito:
    baseUrl: "YOUR_KAITO_BASE_URL"
    apiKey: "YOUR_KAITO_API_KEY"
  slack:
    botToken: "xoxb-YOUR-BOT-TOKEN"
    appToken: "xapp-YOUR-APP-TOKEN"
```

### Deploying with Helm

Navigate to the `deploy/chart` directory and run the following command to install the release (replace `openclaw-bot1` with your desired release name):

```bash
helm install openclaw-bot1 . -n bot --create-namespace
```

This will deploy the OpenClaw SRE Demo to the `bot` namespace.

## Accessing WebVNC

To view the desktop environment and watch the agent in action, you can access the WebVNC interface.

1.  **Port Forward**: Forward the container's VNC port (6901) to your local machine.

    ```bash
    kubectl -n bot port-forward svc/openclaw-bot1 6901:6901
    ```

2.  **Access in Browser**: Open your web browser and navigate to:

    [http://localhost:6901](http://localhost:6901)

    You should now see the desktop environment where the OpenClaw agent operates.
