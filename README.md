# Boards

## Visão Geral do Projeto

Este projeto é um aplicativo de compra, venda e troca de jogos de tabuleiro usados (board games). A estrutura do projeto foi organizada para garantir modularização, manutenção fácil e expansão futura. O foco principal da arquitetura foi garantir a separação clara entre lógica de negócio, gestão de estado, interface do usuário e a manipulação de dados.

Abaixo está descrita a estrutura do projeto, organizada de acordo com os principais diretórios e suas responsabilidades.

## Estrutura de Pastas

### 1. `components`
Este diretório armazena componentes reutilizáveis que são usados em diferentes partes da aplicação. É dividido em:
- **buttons**: Botões customizados, como `big_button.dart`.
- **collection_views**: Visualizações de coleções, como listas e grades.
  - **ad_list_view** e **shop_grid_view** contêm widgets como cartões de anúncio, exibição de imagem e ratings.
- **custon_controllers**: Controladores para entrada de texto com máscaras ou formatação especial, como valores monetários.
- **dialogs**: Diálogos simples para mensagens e perguntas.
- **drawers**: Componentes para barra lateral (drawer) do aplicativo.
- **form_fields**: Campos de formulário personalizados, incluindo campos com máscaras e senhas.
- **texts**: Componentes relacionados a textos longos, como `read_more_text.dart`.
- **widgets**: Componentes diversos, como botões de favoritos, mensagens de carregamento e containers dismissíveis.

### 2. `core`
Responsável pelas funcionalidades centrais e comuns à aplicação.
- **abstracts**: Classes abstratas que fornecem padronizações, como `data_result.dart`.
- **config**: Configurações gerais da aplicação, como `app_info.dart`, que armazena dados sobre a versão do app.
  - **theme**: Configuração de temas e estilos visuais, como cores e fontes.
- **models**: Definições dos modelos de dados do aplicativo (ex.: `ad.dart`, `boardgame.dart`). Esses modelos representam os objetos principais do app.
- **singletons**: Armazenamento de estados persistentes na aplicação, como `app_settings.dart` e `current_user.dart`.
- **state**: Classe básica de controle de estado, utilizada por outras telas.
- **utils**: Utilitários e extensões diversas para facilitar o desenvolvimento, como métodos de formatação e validação.

### 3. `data_managers`
Contém os gerenciadores de dados do aplicativo. Estes elementos fazem a mediação entre a interface do usuário e os repositórios, carregando e armazenando dados necessários para a operação da aplicação.
- Inclui arquivos como `addresses_manager.dart`, `boardgames_manager.dart` e `favorites_manager.dart`.

### 4. `features`
Este diretório é o mais detalhado, contendo as diferentes funcionalidades da aplicação organizadas por área.
- **addresses**: Implementação do cadastro e edição de endereços. Inclui controle de lógica, interface e widgets.
- **chat**: Tela de chat (ainda não implementado).
- **edit_ad**: Funções para criar e editar anúncios. Divide-se em controladores de formulário, visualização de imagens e widgets específicos.
- **favorites**: Tela para exibição dos anúncios marcados como favoritos.
- **filters**: Controle dos filtros utilizados na pesquisa de jogos, com widgets específicos de filtragem.
- **my_account**: Inclui várias subfuncionalidades relacionadas à conta do usuário, como `boardgames`, `mechanics`, `my_ads` e `my_data`.
  - **boardgames** e **mechanics**: Gerenciamento dos jogos cadastrados e suas mecânicas.
  - **my_ads**: Gerenciamento dos anúncios do usuário.
- **payment**: Implementação do sistema de pagamento.
- **shop**: Apresentação dos produtos em grade e detalhes do produto selecionado.
- **signin** e **signup**: Telas de login e cadastro de usuários.

### 5. `repository`
Contém os repositórios que interagem diretamente com as fontes de dados.
- **app_data**: Repositórios que armazenam preferências internas da aplicação, como tema.
- **data**: Repositórios que interagem com o servidor Parse Server para dados principais do app.
- **gov_apis**: Repositórios que interagem com APIs governamentais, como `ibge_repository.dart`.
- **local_data**: Repositórios que usam SQLite para armazenar dados localmente, reduzindo consultas ao servidor.

### 6. `services`
Serviços auxiliares utilizados na aplicação.
- **parse_server**: Métodos para interação com o servidor Parse Server.
- **payment**: Implementação do serviço de pagamento usando Mercado Pago.

### 7. `store`
Esta camada é uma abstração para o banco de dados SQLite.
- **constants**: Contém nomes de tabelas, versões de esquema e scripts de criação/migração.
- **database**: Contém classes para gerenciar, migrar e inicializar o banco de dados.
- **stores**: Classes para operações CRUD em tabelas específicas, como `bg_names_store.dart` e `mechanics_store.dart`.

## Boas Práticas e Padrões Utilizados
- **Modularização e Encapsulamento**: Cada funcionalidade é separada em subpastas dedicadas, garantindo que a manutenção de um módulo seja independente dos outros.
- **Separar Lógica de Negócio, UI e Controle de Estado**: Cada tela (“feature”) é dividida em três componentes principais: `controller` (lógica de negócio), `screen` (interface de usuário) e `store` (gestão de estado e reatividade).
- **Reutilização de Componentes**: Componentes compartilháveis estão localizados na pasta `components`, tornando-os facilmente reutilizáveis entre diferentes partes do projeto.
- **Gestão de Estado Centralizada**: Utilização de stores e singletons, conforme o caso, para gerenciar o estado da aplicação e manter consistência.

## Considerações Finais
A estrutura apresentada permite uma manutenção eficiente do código, tornando as futuras melhorias ou adaptações mais simples de serem realizadas. Componentes reutilizáveis estão claramente organizados, enquanto os dados, a lógica de negócio e a interface do usuário estão devidamente desacoplados. Desta forma, o projeto está preparado para evoluir em complexidade sem comprometer a sua compreensão ou a qualidade do código.


# ChangeLog

## 2024/12/17 - version: 0.5.03+32

Refactored Stripe payment functions to improve modularity and added new helper methods for item validation, reservation, and payment handling.

### Changes made:

1. **functions/index.js**:  
   - Added `const db = admin.firestore();` for streamlined Firestore references.  
   - Refactored `createCheckoutSession` function:  
     - Extracted user authentication logic into `verifyAuth`.  
     - Moved item validation to a new helper `validateItems`.  
     - Added `reserveItems` for reserving items before session creation.  
     - Delegated session creation logic to `createStripeSession`.  
   - Refactored `createPaymentIntent` to use `verifyAuth` for authentication.  
   - Simplified webhook event handling:  
     - Added `handlePaymentSuccess` for successful Stripe payments.  
     - Added `handlePaymentFailure` for failed or expired payments.  

2. **lib/data/models/user_account.dart → lib/data/models/account.dart**:  
   - Renamed `UserAccount` class to `AccountModel` for better naming consistency.  
   - Renamed field `mercadoPagoAccountId` to `accountId`.  

3. **lib/data/models/ad.dart**:  
   - Added a new status `reserved` to the `AdStatus` enum.  

4. **lib/data/models/transaction.dart**:  
   - Renamed `Transaction` class to `TransactionModel` for consistency.  
   - Renamed `TransPayMethod.mercadoPago` to `TransPayMethod.bill`.  

5. **lib/data/services/payment/payment_stripe_service.dart**:  
   - Added `adId` to the item payload sent to the Stripe payment function.  

6. **lib/ui/features/account/my_ads/model/my_ads_dismissible.dart**:  
   - Added support for the new `reserved` status to various methods and conditions.  

7. **lib/ui/features/bag/bag_screen.dart**:  
   - Replaced `print` with `log` for better debugging practices.  

### Conclusion:

The codebase has been modularized with reusable helper functions for Stripe payments and Firestore operations. Naming conventions were improved across models for consistency, and support for the new `reserved` status was added.


## 2024/12/17 - version: 0.5.03+31

This commit introduces the integration of Stripe for payment processing and enhances Android build configurations with code minification using R8.

#### **Files Changed**

1. **android/app/build.gradle**
   - Enabled `minifyEnabled` and configured ProGuard rules for R8.
   - Added `proguardFiles` configuration for `proguard-android-optimize.txt` and `proguard-rules.pro`.

2. **android/app/proguard-rules.pro** *(New File)*
   - Added rules to keep Stripe SDK, Flutter classes, and critical JSON serialization intact.
   - Avoids breaking changes due to reflection and optimization.

3. **android/app/src/main/AndroidManifest.xml**
   - Added `INTERNET` permission for Stripe API communication.

4. **android/app/src/main/kotlin/br/dev/rralves/boards/MainActivity.kt**
   - Changed `MainActivity` to extend `FlutterFragmentActivity` to ensure compatibility with Stripe SDK.

5. **android/build.gradle**
   - Updated `kotlin_version` to `1.8.0`.

6. **android/gradle/wrapper/gradle-wrapper.properties**
   - Upgraded Gradle distribution to `8.9`.

7. **functions/index.js**
   - Added new Firebase Cloud Functions:
     - `createCheckoutSession`: Generates a Stripe Checkout session.
     - `createPaymentIntent`: Creates a PaymentIntent for card payments.
     - `stripeWebhook`: Handles Stripe webhook events (`payment_intent.succeeded` and `payment_intent.payment_failed`).

8. **functions/package.json & functions/package-lock.json**
   - Added dependencies: `stripe`, `dotenv`, and `flatted`.
   - Upgraded `express` and related packages.

9. **lib/main.dart**
   - Initialized `flutter_stripe` with Stripe's publishable key.

10. **lib/core/get_it.dart**
    - Registered `PaymentStripeService` under `IPaymentService`.

11. **lib/data/models/bag_item.dart**
    - Renamed `toMPParameter` to `toPaymentParameters`.

12. **lib/data/services/payment/interfaces/i_payment_service.dart** *(New File)*
    - Defined `IPaymentService` interface for payment abstraction.

13. **lib/data/services/payment/payment_stripe_service.dart** *(New File)*
    - Implemented Stripe payment logic (`createCheckoutSession` and `createPaymentIntent`).

14. **lib/ui/features/bag/bag_controller.dart**
    - Replaced old payment service calls with Stripe's `createCheckoutSession`.

15. **lib/ui/features/bag/bag_screen.dart**
    - Updated logic to initiate Stripe Checkout using the session URL.

16. **lib/ui/features/payment/payment_screen.dart**
    - Removed legacy payment implementation.
    - Replaced WebView logic to load Stripe Checkout session URL.

17. **pubspec.yaml**
    - Added `flutter_stripe` dependency (`^11.3.0`).

18. **pubspec.lock**
    - Updated lock file with new dependencies (`flutter_stripe`, `stripe_android`, `stripe_ios`).

19. **Deleted Files**
    - **lib/data/services/parse_server/functions/cloud_functions.dart**
    - **lib/data/services/parse_server/parse_server_server.dart**
    - **lib/data/services/payment/payment_service.dart**
    - Removed legacy Parse Server-based payment logic.

### Conclusion
This commit replaces the Parse Server-based payment system with Stripe integration, introduces R8 minification, and ensures compatibility with FlutterFragmentActivity. The WebView now handles Stripe Checkout URLs effectively, improving the payment flow.


## 2024/12/12 - version: 0.5.02+30

Added significant improvements and new configurations across various files, enhancing functionality, performance, and development environment.

### Changes made:
1. **.vscode/launch.json**:
   - Added a new launch configuration file for debugging with multiple modes: normal, profile, and release.

2. **android/app/src/main/AndroidManifest.xml**:
   - Added permissions for `READ_EXTERNAL_STORAGE` and `WRITE_EXTERNAL_STORAGE`.

3. **android/build.gradle**:
   - Updated Kotlin version to `1.7.10`.
   - Updated Gradle plugin to version `8.0.0`.

4. **lib/data/models/ad.dart**:
   - Renamed `boardgame` to `boardgameId` for consistency.

5. **lib/data/models/boardgame.dart**:
   - Renamed `mechsPsIds` to `mechIds` for better naming clarity.

6. **lib/data/store/database/database_manager.dart**:
   - Removed the `_copyBggDb` method, simplifying database handling logic.

7. **lib/logic/managers/mechanics_manager.dart**:
   - Adjusted conditional structure for clarity in the `getAll` result evaluation.

8. **lib/ui/components/buttons/big_button.dart**:
   - Replaced `color.withOpacity()` with `color.withValues()` for alpha adjustment.

9. **lib/ui/components/collection_views/ad_list_view/ad_list_view.dart**:
   - Replaced multiple instances of `.withOpacity()` with `.withValues()` for better clarity and consistency.

10. **lib/ui/components/collection_views/shop_grid_view/shop_grid_view.dart**:
    - Added a `reloadAds` method to the widget for refreshing ads.
    - Simplified the structure by removing unused image loading logic.

11. **lib/ui/components/dialogs/simple_message.dart**:
    - Removed an unused `default` case in the `_getIcon` method.

12. **lib/ui/components/drawers/custom_drawer.dart**:
    - Used `.withValues()` for adjusting alpha on colors.

13. **lib/ui/components/state_messages/state_*_message.dart**:
    - Replaced `withOpacity` with `withValues` for color modifications.

14. **lib/ui/features/account/my_ads/my_ads_screen.dart**:
    - Updated the floating action button background color using `withValues`.

15. **lib/ui/features/favorites/favorites_controller.dart**:
    - Added a `reloadAds` method to reload favorite ads.

16. **pubspec.yaml**:
    - Updated the `file_picker` dependency to a local path for custom modifications.

17. **pubspec.lock**:
    - Updated multiple dependencies to newer versions for improved functionality and compatibility.

### Conclusion:

These changes bring substantial improvements to the codebase, including enhanced maintainability, better naming conventions, and updated dependencies for improved performance and development flexibility.


## 2024/12/12 - version: 0.5.01+29

Added improvements and fixes across multiple files for better functionality, consistency, and performance.

### Changes made:
1. **android/app/src/main/AndroidManifest.xml**:
   - Enabled `OnBackInvokedCallback` with the attribute `android:enableOnBackInvokedCallback`.
   - Added a comment reminding to set `android:usesCleartextTraffic` to "false" in production.

2. **lib/data/repository/firebase/fb_ads_repository.dart**:
   - Added `status` filter to the `get` method.
   - Refactored query-building logic by extracting it into a new `_applyFilter` method for better maintainability.
   - Updated the `update` method to return the updated `AdModel` instead of `null`.

3. **lib/data/repository/gov_apis/viacep_repository.dart**:
   - Updated `getLocalByCEP` to return a `DataResult` instead of throwing exceptions for error handling.
   - Added import for `DataResult`.

4. **lib/logic/managers/mechanics_manager.dart**:
   - Fixed a log message formatting issue in `namesFromIdList`.

5. **lib/ui/components/state/state_store.dart**:
   - Enhanced state management methods (`setStateInitial`, `setStateLoading`, `setStateSuccess`) to reset `errorMessage`.

6. **lib/ui/features/account/my_ads/my_ads_screen.dart**:
   - Replaced `Icons.delete` with `Symbols.delete` for improved consistency.
   - Adjusted formatting in `_editAd` for better readability.

7. **lib/ui/features/addresses/edit_address/edit_address_controller.dart**:
   - Updated `getAddressFromViacep` to handle `DataResult` properly.
   - Adjusted error handling to set state as successful when an error occurs.

8. **lib/ui/features/addresses/edit_address/edit_address_store.dart**:
   - Removed unused setter methods (`setStreet`, `setNeighborhood`, etc.).
   - Added `setZipCodeInvalid` method to manage invalid ZIP code errors.

9. **lib/ui/features/addresses/edit_address/widgets/address_form.dart**:
   - Wrapped `CustomFormField` for `Número` with a `ValueListenableBuilder` for reactive error handling.
   - Commented out unused validators for neighborhood, state, and city.

10. **lib/ui/features/edit_ad/edit_ad_controller.dart**:
    - Updated `saveAd` to differentiate between adding and updating ads based on the `id`.

11. **lib/ui/features/shop/product/product_screen.dart**:
    - Added padding to `ImageCarousel` for better visual layout.

12. **lib/ui/features/shop/product/widgets/gama_data/game_data_widget.dart**:
    - Adjusted text styles dynamically based on `colorScheme`.
    - Improved layout customization with additional padding and styling.

13. **lib/ui/features/shop/shop_controller.dart**:
    - Refactored `_initialize` to separate the logic into a `reloadAds` method for better clarity and reusability.

14. **lib/ui/features/shop/shop_screen.dart**:
    - Added padding to the body for consistent UI spacing.
    - Improved structure and formatting for better readability.

### Conclusion:
These updates significantly enhance the code's clarity, maintainability, and functionality, laying the groundwork for more robust features and a better user experience.


## 2024/12/12 - version: 0.5.00+28

This commit refactors several methods in the mechanics manager to improve naming consistency and better align with the mechanic ID handling. It also introduces new UI elements, such as updated controllers and widgets for displaying boardgame data, and updates relevant files to reflect these changes.

### Changes made:
1. **lib/logic/managers/mechanics_manager.dart**:
   - Renamed method `nameFromPsId` to `nameFromMechId` for better clarity and consistency with the mechanic ID.
   - Renamed method `namesFromPsIdList` to `namesFromMechIdList` to reflect the updated method naming.
   - Renamed method `mechanicOfPsId` to `mechanicOfMechId` to match the new naming convention for mechanic IDs.
   - Updated internal references in the methods to handle mechanic ID (`mechId`) consistently.
   - Added a new method `mechFromId` to fetch mechanics by ID from the list.
   - Updated the method `get` to accept `mechId` instead of `psId` when fetching mechanic data from the repository.

2. **lib/main.dart**:
   - Commented out `FirebaseMessaging.onBackgroundMessage` for background message handling temporarily.

3. **lib/ui/features/account/boardgames/edit_boardgame/edit_boardgame_form/edit_boardgame_form_controller.dart**:
   - Updated the call to `mechManager.namesFromPsIdList` to `mechManager.namesFromMechIdList` for consistency with the new naming of methods.
   
4. **lib/ui/features/account/tools/tools_controller.dart**:
   - Updated the method call `mechManager.getMechanics()` to `mechManager.getAll()` to use the new method for fetching mechanics.

5. **lib/ui/features/filters/filters_controller.dart**:
   - Updated the method call `mechManager.namesFromPsIdList` to `mechManager.namesFromMechIdList` for consistency with the updated method names.

6. **lib/ui/features/shop/product/product_screen.dart**:
   - Renamed `GameData` widget to `GameDataWidget` to resolve naming conflict and maintain consistency.

7. **lib/ui/features/shop/product/widgets/gama_data/game_data_controller.dart**:
   - Created a new controller class `GameDataController` to handle boardgame data and mechanics fetching.
   - Added `loadBoardgame` method to fetch boardgame details asynchronously and update the UI state accordingly.

8. **lib/ui/features/shop/product/widgets/gama_data/game_data_store.dart**:
   - Created a new store class `GameDataStore` to manage state for the boardgame data loading process.

9. **lib/ui/features/shop/product/widgets/gama_data/game_data_widget.dart**:
   - Created `GameDataWidget` as a new widget to display detailed boardgame data and mechanics.
   - Added logic to display boardgame information such as players, duration, age, and mechanics, as well as handle loading and error states.

10. **lib/ui/features/shop/product/widgets/game_data.dart**:
    - Removed old `GameData` widget in favor of the newly created `GameDataWidget`.

### Conclusion:
The commit refactors the `MechanicsManager` methods to improve consistency in naming conventions and the handling of mechanic IDs. It also introduces new UI elements and controllers for managing and displaying boardgame data. Additionally, it updates method calls across various files to align with the new naming and method structure, ensuring better code clarity and maintainability.


## 2024/12/11 - version: 0.5.00+27

This commit introduces significant updates to the messaging functionality, enabling Firebase Messaging for notifications, restructuring state management, and improving user experience in the app. Key changes include the addition of Firebase Messaging service, restructuring state message widgets, and various enhancements in controllers and stores.

### Changes made:

1. **firestore.rules**:
   - Updated read and create permissions for messages to allow any authenticated user.
   - Simplified permission logic and added inline comments for clarity.

2. **functions/index.js**:
   - Added a new `notifySpecificUser` function to send Firebase notifications when a message is created.
   - Introduced imports for `getFirestore` and `getMessaging` to handle Firestore and Firebase Messaging operations.
   - Updated Firebase Functions version to `6.1.2`.

3. **lib/core/get_it.dart**:
   - Registered `FirebaseMessagingService` as a singleton.
   - Added `MessagesManager` as a factory for managing messages.

4. **lib/data/models/message.dart**:
   - Added the `targetUserId` property for targeting specific users in messages.
   - Updated methods (`toMap`, `fromMap`, `copyWith`, and `toString`) to include `targetUserId`.

5. **lib/data/models/user.dart**:
   - Added `fcmToken` property to store Firebase Cloud Messaging token.
   - Updated `copyWith` and `toString` methods to handle the new `fcmToken`.

6. **lib/data/repository/firebase/fb_user_repository.dart**:
   - Integrated `FirebaseMessagingService` to fetch and update the user's FCM token during authentication.

7. **lib/data/services/firebase/firebase_messaging_service.dart**:
   - Implemented a new service to manage Firebase Messaging tokens and permissions.
   - Added token refresh and update logic for Firestore.

8. **lib/logic/managers/messages_manager.dart**:
   - Created a new manager to handle message operations, including sending and reading messages.

9. **lib/main.dart**:
   - Configured Firebase Messaging handlers for foreground, background, and app launch notifications.

10. **lib/ui/components/widgets/app_snackbar.dart**:
    - Added a new reusable component for displaying SnackBar messages in the app.

11. **lib/ui/features/shop/product/message/message_controller.dart**:
    - Refactored to use `MessagesManager` for sending and reading messages.
    - Improved error handling and logging.

12. **lib/ui/features/shop/product/message/message_store.dart**:
    - Removed redundant `messages` state and centralized management in `MessagesManager`.

13. **lib/ui/features/shop/product/message/message_widget.dart**:
    - Updated to use `MessagesManager` and improved error feedback with `AppSnackbar`.

14. **lib/ui/features/shop/product/message/widget/chat_bubble.dart**:
    - Adjusted layout and styling for better message display, including padding and alignment.

15. **lib/ui/components/widgets/state_*.dart → lib/ui/components/state_messages/state_*.dart**:
    - Renamed and reorganized state message components into a dedicated directory.

16. **pubspec.yaml & pubspec.lock**:
    - Added `firebase_messaging` dependency.

### Conclusion:

These updates significantly enhance the messaging functionality by integrating Firebase Messaging, improving state management, and reorganizing UI components. The changes ensure better scalability and user experience, while maintaining a clean and modular codebase.


## 2024/12/11 - version: 0.5.00+26

This commit introduces a robust messaging functionality for the shop product feature, enhancing user interaction through a new message module. Key updates include adding a message widget, store, and controller, along with improvements to Firestore rules and model definitions.

### Changes made:

1. **firestore.rules**:
   - Adjusted `allow read` condition for messages to simplify access rules.
   - Updated `allow create` to replace `allow update` for message creation.

2. **lib/core/get_it.dart**:
   - Registered `IMessageRepository` with `FbMessageRepository`.

3. **lib/data/models/message.dart**:
   - Added `senderName` and `ownerId` fields to `MessageModel`.
   - Updated `toMap` and `fromMap` methods to handle new fields.
   - Enhanced `copyWith` and `toString` methods to include the new properties.

4. **lib/data/repository/firebase/fb_message_repository.dart**:
   - Changed `IMessagesRepository` reference to `IMessageRepository`.
   - Adjusted `get` method to order messages by `timestamp` in descending order.

5. **lib/data/repository/interfaces/remote/i_messages_repository.dart → lib/data/repository/interfaces/remote/i_message_repository.dart**:
   - Renamed file and interface from `IMessagesRepository` to `IMessageRepository`.

6. **lib/ui/features/shop/product/message/message_controller.dart**:
   - Introduced `MessageController` to handle message operations, including sending and reading messages.

7. **lib/ui/features/shop/product/message/message_store.dart**:
   - Added `MessageStore` to manage message state and lifecycle, including a `TextEditingController` for message input.

8. **lib/ui/features/shop/product/message/message_widget.dart**:
   - Created `MessageWidget` to integrate messaging functionality into the UI.
   - Included input field and message list display with state management.

9. **lib/ui/features/shop/product/message/widget/chat_bubble.dart**:
   - Added `ChatBubble` and `ChatBubbleTriangle` widgets for visually distinct message display styles.

10. **lib/ui/features/shop/product/product_screen.dart**:
    - Integrated `MessageWidget` into the product screen for user interaction.

### Conclusion:

These updates significantly enhance the shop product feature by adding a messaging system that improves communication between users. The modular structure ensures maintainability, while the refined Firestore rules and model updates align with best practices.


## 2024/12/10 - version: 0.0.05+25

This commit focuses on the restructuring of the `lib/` directory to align with the architectural layers of the application, separating core functionality, data management, business logic, and user interface components into distinct directories.

### Changes made:

1. **Updated Directory Structure:**
   - The `lib/` directory was reorganized into the following structure:
     ```
     lib/
     ├── app.dart
     ├── core/
     │   ├── abstracts/
     │   ├── config/
     │   ├── get_it.dart
     │   ├── singletons/
     │   ├── theme/
     │   └── utils/
     ├── data/
     │   ├── models/
     │   ├── repository/
     │   ├── services/
     │   └── store/
     ├── firebase_options.dart
     ├── logic/
     │   └── managers/
     ├── main.dart
     └── ui/
         ├── components/
         └── features/
     ```

2. **Relocation of Files:**
   - **From `features/` to `ui/features/`:**
     - All feature-specific files were moved under `ui/features/` to maintain consistency and separation of user interface elements.
   - **From `data_managers/` to `logic/managers/`:**
     - Business logic managers were relocated to `logic/managers/` to better align with the purpose of the layer.
   - **From `components/` to `ui/components/`:**
     - Shared UI components were moved to `ui/components/` for centralized management.

3. **Updated Import Paths:**
   - All affected files had their import paths updated to reflect the new directory structure.

### Conclusion:
This restructuring enhances the maintainability and scalability of the codebase by clearly separating responsibilities into distinct layers. It ensures better adherence to architectural best practices and simplifies navigation for developers.


## 2024/12/10 - version: 0.0.05+24

This commit introduces significant updates and new features, including enhancements in Firestore rules, message management, and address handling. Additionally, a new `MessageModel` and corresponding repository were added to improve message-related operations.

### Changes made:

1. **firestore.rules**:
   - Reformatted Firestore rules for better readability and maintainability.
   - Added permissions for the new `messages` subcollection.
   - Enhanced rules to control updates of `read` and `answered` fields in `messages`.

2. **lib/core/models/message.dart**:
   - Created a new `MessageModel` class to represent chat messages with fields such as `id`, `senderId`, `timestamp`, `text`, `read`, and `answered`.
   - Implemented `toMap`, `fromMap`, and `copyWith` methods for easy conversion and manipulation of message data.

3. **lib/data_managers/addresses_manager.dart**:
   - Updated the method `getAddresesesFromUserId` to use the renamed `get` method from the address repository.

4. **lib/repository/data/firebase/fb_address_repository.dart**:
   - Renamed the `getAll` method to `get` for consistency.
   - Replaced inline string `'id'` with the constant `keyAddressId` for better maintainability.
   - Adjusted address creation and update logic to remove `id` using the constant `keyAddressId`.

5. **lib/repository/data/firebase/fb_message_repository.dart**:
   - Added a new repository to handle message-related operations.
   - Implemented methods for fetching, sending, and updating message statuses in Firestore.
   - Introduced error handling with `_handleError`.

6. **lib/repository/data/interfaces/i_address_repository.dart**:
   - Renamed `getAll` method to `get` in the address repository interface.

7. **lib/repository/data/interfaces/i_messages_repository.dart**:
   - Created a new interface for managing messages.
   - Defined methods for fetching messages, sending a new message, and updating message statuses.

### Conclusion:

These updates significantly enhance the project's functionality and maintainability by introducing new features and improving existing ones. The addition of the `MessageModel` and message repository provides a solid foundation for managing chat functionality. Firestore rules and address management were refined for better consistency and reliability.


## 2024/12/09 - version: 0.0.04+23

This commit introduces significant enhancements and bug fixes across multiple modules, including Firestore rules, UI components, model improvements, and repository refinements.

### Changes made:

1. **firestore.rules**:
   - Added `create` permission to allow logged-in users to create ads with an ownership check.
   - Separated `update` and `delete` permissions for ad ownership, replacing the generic `write` permission.

2. **lib/components/collection_views/shop_grid_view/widgets/ad_shop_view.dart**:
   - Updated `note` in `OwnerRating` to use a default value of `0` if `ownerRate` is `null`.

3. **lib/components/texts/parse_rich_text.dart**:
   - Added a new utility function `parseRichText` to parse text with bold (`**`) and italic (`*`) formatting.
   - Provided an example usage in a Flutter widget.

4. **lib/core/models/ad.dart**:
   - Enhanced `mechanicsIds` and `images` parsing to handle dynamic types more robustly.

5. **lib/core/models/boardgame.dart**:
   - Added `toSimpleString` method for a concise and formatted board game description.

6. **lib/features/edit_ad/edit_ad_controller.dart**:
   - Integrated user address initialization in the `init` method.
   - Removed redundant assignment of `ownerId` in the `saveAd` method.

7. **lib/features/edit_ad/edit_ad_form/edit_ad_form.dart**:
   - Updated the board game info display to use the `parseRichText` utility for better formatting.

8. **lib/features/edit_ad/edit_ad_store.dart**:
   - Added user details initialization (`ownerId`, `ownerName`, `ownerState`, `ownerCity`) in the ad creation process.
   - Updated `setBGInfo` to include a formatted board game description.

9. **lib/features/shop/product/product_screen.dart**:
   - Set `ownerRate` to default to `0` if `null`.

10. **lib/repository/data/firebase/common/fb_functions.dart**:
    - Modified the `_bucket` getter to dynamically adjust based on `kDebugMode`.

11. **lib/repository/data/firebase/fb_ads_repository.dart**:
    - Fixed inconsistent `copyWith` usage in mapping Firestore documents to models.

12. **lib/repository/data/firebase/fb_boardgame_repository.dart**:
    - Refined `copyWith` usage for creating board game models.

13. **lib/repository/data/firebase/fb_favorite_repository.dart**:
    - Fixed an import path for `DataResult`.

### Conclusion:

These updates enhance the application's robustness, ensure better adherence to Firestore security rules, and improve user experience through refined UI components and reliable data handling. Additionally, formatting and utility improvements streamline the development process and code maintainability.


## 2024/12/09 - version: 0.0.04+22

This commit implements significant enhancements across the address management and ad editing features, including improvements in the selection, validation, and synchronization logic of addresses, as well as streamlined workflows for ad-related operations.

### Changes made:

1. **lib/core/models/address.dart**:
   - Made all fields in the `AddressModel` mutable to allow updates during runtime.

2. **lib/core/singletons/current_user.dart**:
   - Added a getter `selectedAddress` to retrieve the currently selected address.

3. **lib/data_managers/addresses_manager.dart**:
   - Introduced `_setSelectedInIndex` and `_indexOf` private methods for efficient address selection logic.
   - Improved address selection logic with safe error handling and database synchronization.
   - Refactored methods to ensure consistency in naming and logic, including `deleteIndex` for better clarity.

4. **lib/features/addresses/addresses_controller.dart**:
   - Simplified address selection and removal methods.
   - Removed unnecessary state tracking, relying instead on the centralized manager.

5. **lib/features/addresses/addresses_screen.dart**:
   - Introduced a `Dismissible` widget for improved user interaction, allowing addresses to be removed with a swipe.
   - Updated UI to provide feedback for loading and errors during address removal or selection.

6. **lib/features/addresses/addresses_store.dart**:
   - Simplified the `AddressesStore` class by removing unused state management fields.

7. **lib/features/addresses/edit_address/edit_address_controller.dart**:
   - Replaced manual state management with `EditAddressStore` integration.
   - Enhanced address validation and error handling logic.

8. **lib/features/addresses/edit_address/edit_address_screen.dart**:
   - Integrated the `EditAddressStore` to handle state and validation.
   - Refactored the save and back navigation methods for consistency.

9. **lib/features/addresses/edit_address/edit_address_store.dart**:
   - Created a new `EditAddressStore` for modular validation and state management of address fields.

10. **lib/features/addresses/edit_address/widgets/address_form.dart**:
    - Updated form field bindings to use `EditAddressStore` for validation and error handling.
    - Improved user experience with dynamic error feedback through `ValueListenableBuilder`.

11. **lib/features/edit_ad/edit_ad_controller.dart**:
    - Updated `setSelectedAddress` to automatically fetch the selected address from the current user.

12. **lib/features/edit_ad/edit_ad_form/edit_ad_form.dart**:
    - Refactored address selection logic to remove unnecessary parameter passing.

13. **lib/features/edit_ad/edit_ad_screen.dart**:
    - Simplified layout and state handling for the ad edit screen.

14. **lib/repository/data/firebase/fb_address_repository.dart**:
    - Added `updateSelection` method to handle address selection synchronization with Firestore.

15. **lib/repository/data/interfaces/i_address_repository.dart**:
    - Updated the interface to include the new `updateSelection` method.

### Conclusion:

This commit enhances the address and ad management features by introducing modular state management, better synchronization with the database, and improved user experience through dynamic UI feedback. The refactor aligns the codebase with best practices, ensuring maintainability and scalability for future developments.


## 2024/12/08 - version: 0.0.04+21

This commit introduces enhancements to various parts of the application, including Android Manifest updates, AdsManager logic refinements, Firebase Ads Repository pagination improvements, and Firebase Storage rules adjustments for user authentication.

### Changes made:

1. **android/app/src/main/AndroidManifest.xml**:
   - Added the `UCropActivity` for the `image_cropper` package with fixed screen orientation and theme configuration.

2. **lib/data_managers/ads_manager.dart**:
   - Updated imports to use absolute paths for consistency.
   - Replaced `maxAdsPerList` constant with `docsPerPage` for pagination logic consistency.
   - Fixed list update logic by referencing `_ads` directly to avoid potential misuse.
   - Improved readability and logic consistency in `_getMoreAds` method.

3. **lib/repository/data/firebase/fb_ads_repository.dart**:
   - Added a `PaginatedResult` class for improved handling of paginated data.
   - Introduced `_lastFetchedDocument` to manage pagination state internally.
   - Replaced offset-based pagination with `startAfterDocument` for more efficient Firestore queries.
   - Updated logic to reset pagination when fetching the first page.
   - Enhanced query logic with dynamic filtering and proper pagination.

4. **storage.rules**:
   - Adjusted Firebase Storage rules to allow authenticated users to read and write files.

### Conclusion:

These updates improve the maintainability and functionality of the application. The AndroidManifest now supports the `image_cropper` package. The AdsManager and Firebase Ads Repository enhancements provide a more robust and efficient pagination mechanism. Finally, the Firebase Storage rules ensure secure file access by restricting it to authenticated users.


## 2024/12/07 - version: 0.0.04+20

This commit refines the advertisement management system by enhancing the repository interface, improving method signatures, and updating Firestore integration for better flexibility and performance.

### Changes made:

1. **lib/features/account/my_ads/my_ads_controller.dart**:
   - Updated `_getAds` method to use named parameters `ownerId` and `status` when calling `adRepository.getMyAds`.
   - Refactored `updateStatus` method to pass `adsId`, `status`, and `quantity` explicitly to `adRepository.updateStatus`.
   - Modified `deleteAd` method to use the updated `adRepository.updateStatus` method for marking ads as deleted.

2. **lib/repository/data/firebase/fb_ads_repository.dart**:
   - Added a new constant `keyAdsOwnerId` for the `ownerId` field in Firestore.
   - Implemented the `getMyAds` method to fetch ads based on `ownerId` and `status` using Firestore queries.
   - Updated `updateStatus` method to accept named parameters `adsId`, `status`, and `quantity` for improved clarity and flexibility.
   - Removed obsolete and unimplemented methods, including old `getMyAds` and placeholders for `moveAdsAddressTo`.

3. **lib/repository/data/interfaces/i_ads_repository.dart**:
   - Refactored method signatures in the `IAdsRepository` interface to use named parameters for clarity.
   - Removed extensive and outdated documentation for methods no longer relevant.
   - Updated `updateStatus` method to require `adsId`, `status`, and `quantity` as named parameters.
   - Simplified and streamlined method declarations to align with the latest implementation in Firestore.

### Conclusion:

These updates improve the modularity and maintainability of the advertisement management codebase. The repository interface now supports more flexible operations, and Firestore queries are streamlined for better performance. Deprecated methods and redundant documentation were cleaned up, ensuring the code remains clear and concise.


## 2024/12/07 - version: 0.0.04+19

This commit introduces a major overhaul to replace the Parse Server implementation with Firebase, refactors model structures, simplifies repository logic, and removes unused Parse-specific functions and constants. Key changes include adjustments to model properties, repository interfaces, and managers to support Firebase operations and removal of Parse Server dependencies.

### Changes made:

1. **lib/components/collection_views/ad_list_view/widgets/ad_card_view.dart**:
   - Updated property accessors for `AdTextInfo` to use `ownerCity` and `ownerState` instead of `address`.

2. **lib/core/models/ad.dart**:
   - Removed `AddressModel` and `UserModel` references.
   - Added `ownerState` property.
   - Replaced `boardgame` with `boardgameId` as a `String`.
   - Adjusted `toMap` and `fromMap` to use simplified logic with Firebase-friendly properties.
   - Replaced `status` and `condition` indices with their respective `name` values.

3. **lib/core/models/filter.dart**:
   - Renamed `mechanicsPsId` to `mechanicsId` for clarity.

4. **lib/core/utils/extensions.dart**:
   - Added `EnumFromNameExtension` to simplify enum lookups by name.
   - Renamed `StringExtension` to `OnlyNumberString`.

5. **lib/data_managers/ads_manager.dart**:
   - Changed repository interface from `IAdRepository` to `IAdsRepository`.
   - Adjusted `getAdById` to handle nullable `AdModel`.

6. **lib/features/account/my_ads/my_ads_controller.dart**:
   - Updated repository dependency to `IAdsRepository`.
   - Updated logic for handling user `id` directly.

7. **lib/features/addresses/addresses_controller.dart**:
   - Refactored to remove Parse Server dependency.
   - Commented out `moveAdsAddressAndRemove` functionality temporarily.

8. **lib/features/addresses/addresses_screen.dart**:
   - Simplified address removal logic and commented out Parse-related sections.

9. **lib/features/bag/bag_controller.dart**:
   - Adjusted `getAdById` to handle nullable `AdModel`.

10. **lib/features/edit_ad/edit_ad_controller.dart**:
    - Updated repository dependency to `IAdsRepository`.
    - Simplified logic for saving ads and owner management.

11. **lib/features/edit_ad/edit_ad_store.dart**:
    - Replaced `address` with `ownerCity` and `ownerState`.
    - Updated `setAddress` and `setBGInfo` to reflect model changes.

12. **lib/features/filters/filters_controller.dart**:
    - Updated filter logic to use `mechanicsId`.

13. **lib/features/shop/product/product_screen.dart**:
    - Replaced `boardgame` references with `boardgameId`.

14. **lib/features/shop/product/widgets/game_data.dart**:
    - Replaced `AdModel` with `String bgId` for board game data display.

15. **lib/features/shop/shop_controller.dart**:
    - Updated repository dependency to `IAdsRepository`.

16. **lib/get_it.dart**:
    - Replaced Parse Server repositories with Firebase equivalents.
    - Registered `FbAdsRepository` for `IAdsRepository`.

17. **lib/repository/data/common/constantes.dart**:
    - Added a new constant `docsPerPage`.

18. **lib/repository/data/firebase/common/fb_functions.dart**:
    - Introduced `uploadMultImages` to handle bulk image uploads.

19. **lib/repository/data/firebase/fb_ads_repository.dart**:
    - Added new Firebase Ads Repository implementing `IAdsRepository`.

20. **lib/repository/data/firebase/fb_boardgame_repository.dart**:
    - Simplified board game repository logic for Firebase.

21. **lib/repository/data/interfaces/i_ad_repository.dart → lib/repository/data/interfaces/i_ads_repository.dart**:
    - Renamed file and class for consistency.
    - Adjusted method signatures for Firebase compatibility.

22. **Deleted Parse Server-specific files**:
    - Removed `constants.dart`, `errors_mensages.dart`, `parse_to_model.dart`, and `ps_functions.dart` from the Parse Server module.
    - Deleted `ps_ad_repository.dart` and `ps_boardgame_repository.dart`.

### Conclusion:

This commit streamlines the application by transitioning to Firebase and deprecating the Parse Server. It enhances maintainability, reduces dependencies, and optimizes repository logic for Firebase operations. Further improvements are expected during testing and feedback integration.


## 2024/12/06 - version: 0.0.04+18

This commit includes several updates, improvements, and bug fixes across multiple files, focusing on enhanced functionality, better error handling, and improved integration with Firebase and Parse Server. Key changes include modifications to Cloud Functions, updated Firestore rules, and improvements in error code management. Additionally, this commit fixes issues that previously blocked the project from running on the Firebase Emulator Suite, making local development more seamless.

### Changes made:

1. **firebase.json**:
   - Added `runtime: "nodejs18"` to the Cloud Functions configuration.
   - Moved the `storage` section to the end of the file for better organization.

2. **firestore.rules**:
   - Changed read access for `boardgames`, `bgnames`, `favorites`, and `mechanics` collections to allow public read access (`allow read: if true`).
   - Added rules for the `favorites` collection, allowing read and write access for all users.

3. **functions/index.js**:
   - Introduced emulator configuration for Firestore and Firebase Auth.
   - Refactored Cloud Functions `assignDefaultUserRole` and `changeUserRole` to use `onCall` instead of `onRequest`.
   - Improved error handling and logging within the functions.

4. **lib/main.dart**:
   - Updated Firebase Auth emulator port from `4000` to `9099`.

5. **lib/repository/data/firebase/common/errors_codes.dart**:
   - Added new error codes: `claimsError`, `verificationFailed`, `emailAlreadyInUse`, and `weakPassaword`.

6. **lib/repository/data/firebase/common/fb_functions.dart**:
   - Enhanced Cloud Functions instance to automatically configure for emulator use in development.
   - Improved `assignDefaultUserRole` and `changeUserRole` functions with better error handling and logging.

7. **lib/repository/data/firebase/fb_favorite_repository.dart**:
   - Fixed error handling method names in `add` and `getAll` methods.

8. **lib/repository/data/firebase/fb_user_repository.dart**:
   - Improved handling of user profile updates using a new `_updateProfile` method.
   - Enhanced error handling and logging for multiple methods, including `sendPhoneVerificationSMS` and `submitVerificationCode`.
   - Added validation for Cloud Function results and improved error reporting.

9. **lib/repository/data/parse_server/ps_ad_repository.dart**:
   - Fixed a typo in the error handling method (`PSAdRepository` instead of `PASdRepository`).
   - Adjusted method name in error handling from `get` to `getById` for clarity.

### Conclusion:

This update not only resolves several bugs but also ensures the project can now run successfully on the Firebase Emulator Suite. This improvement significantly streamlines local development, while the enhanced logging, error handling, and refactored Cloud Functions contribute to better maintainability and debugging efficiency.


## 2024/12/06 - version: 0.0.04+17

This commit introduces several enhancements and refactorings across various files to improve functionality, code clarity, and Firebase integration. Key changes include renaming methods, updating mechanics-related properties, and adding new utility functions for Firebase Storage.

### Changes made:

1. **Makefile**:
   - Renamed `firebase_emu` target to `firebase_emu_with_go`.
   - Updated `firebase_emu` target to start Firebase emulators with data import.

2. **firebase.json**:
   - Added `region` field with value `southamerica-east1` for Firebase Functions.

3. **firebase.json_old**:
   - Deleted this redundant configuration file.

4. **firestore.rules**:
   - Added reusable function `isAdminOrEditor` for role-based permissions.
   - Updated rules for `users`, `addresses`, `boardgames`, `bgnames`, `mechanics`, and `ads` collections for better access control.

5. **functions/index.js**:
   - Explicitly set the region to `southamerica-east1` for Cloud Functions.
   - Enhanced logging in `syncBoardgameToBGNames` function.
   - Refactored `AssignDefaultUserRole` and `ChangeUserRole` functions for clarity and improved error handling.

6. **lib/app.dart**:
   - Renamed route from `CheckPage` to `ToolsScreen`.

7. **lib/core/models/boardgame.dart**:
   - Renamed `mechsPsIds` to `mechIds` for consistency.
   - Updated related methods and factory constructors.

8. **lib/data_managers/boardgames_manager.dart**:
   - Replaced Parse Server image URL validation with Firebase Storage URL validation using `FbFunctions`.

9. **lib/features/account/tools**:
   - Renamed `CheckPage`, `CheckController`, and `CheckStore` to `ToolsScreen`, `ToolsController`, and `ToolsStore`.
   - Added `cleanDatabase` functionality for resetting local data.

10. **lib/features/edit_ad/edit_ad_controller.dart**:
    - Updated mechanics property usage to `mechIds`.

11. **lib/features/splash/splash_page_screen.dart**:
    - Fixed import paths for consistency.

12. **lib/main.dart**:
    - Added Firebase Storage emulator connection for local development.

13. **lib/repository/data/firebase/common/fb_functions.dart**:
    - Introduced new utility methods for Firebase Storage operations.
    - Refactored role management functions for better modularity.

14. **lib/repository/data/firebase/fb_boardgame_repository.dart**:
    - Integrated image upload functionality via `FbFunctions`.

15. **lib/repository/data/firebase/fb_user_repository.dart**:
    - Adjusted token refresh behavior based on build mode.

16. **lib/store/database/database_manager.dart**:
    - Refactored methods to support resetting multiple database tables.

17. **pubspec.lock**:
    - Updated dependencies for `firebase_core`, `firebase_storage`, and related libraries.

18. **pubspec.yaml**:
    - Added `firebase_storage` dependency.

### Conclusion:

These updates enhance the functionality and maintainability of the project by introducing better naming conventions, improved Firebase integration, and modularized utilities. The refactorings and new features simplify local database management and extend Firebase functionality, paving the way for a more robust application architecture.


## 2024/12/05 - version: 0.0.04+16

This commit introduces multiple improvements and refactors across the project, including Firebase configurations, enhancements in boardgame management, and migrating key functions for better integration and performance.

### Changes made:

1. **.firebaserc**:
   - Added `targets` for `functions` and `functions_go` directories, specifying their sources.

2. **Makefile**:
   - Removed the commented-out `firebase_functions_deploy` section.
   - Added `functions_deploy` target for deploying Firebase functions.

3. **firebase.json**:
   - Added a new section for `storage` with its `rules`.
   - Updated `functions` to reflect the correct source directory and include a `predeploy` script.

4. **firebase.json_old**:
   - Created a backup file to preserve the previous Firebase configurations for reference.

5. **functions/.eslintrc.js**:
   - Introduced ESLint configuration for the Firebase Functions directory.

6. **functions/.gitignore**:
   - Added rules to ignore `node_modules` and local files.

7. **functions/index.js**:
   - Introduced multiple Firebase Cloud Functions, including:
     - `syncBoardgameToBGNames`: Syncs boardgame data with `bgnames` upon creation.
     - `deleteBGName`: Deletes corresponding `bgnames` entry when a boardgame is deleted.
     - `AssignDefaultUserRole` and `ChangeUserRole`: Manage user roles using custom claims.

8. **functions_go/function.go**:
   - Migrated to a new directory `functions_go`.
   - Added enhancements for handling Firebase Auth and Firestore operations.

9. **functions_go_tests/functions/function.go**:
   - Refactored Firebase initialization and added logs for debugging.

10. **lib/data_managers/boardgames_manager.dart**:
    - Renamed `_localBGsList` to `_bgList` for better clarity.
    - Updated related methods and properties to align with the new naming.
    - Enhanced `_updateLocalDatabaseIfNeeded` and `_updateLocalBgNames` methods.

11. **lib/features/account/boardgames/boardgames_controller.dart**:
    - Replaced `localBGList` with `bgList` in the `BoardgamesController`.

12. **lib/repository/data/firebase/common/fb_functions.dart**:
    - Removed the `getBoardgameNames` method as the logic was moved to `FbBoardgameRepository`.

13. **lib/repository/data/firebase/fb_boardgame_repository.dart**:
    - Migrated `getNames` logic to fetch data directly from Firestore instead of calling Cloud Functions.
    - Added support for the `bgnames` collection.

14. **package-lock.json**:
    - Updated the package-lock file to reflect the changes in project dependencies.

### Conclusion:

These updates improve project organization, enhance Firebase integration, and streamline boardgame data management. Refactoring ensures clearer naming conventions and removes redundant functions, resulting in a more maintainable and efficient codebase.


## 2024/12/04 - version: 0.0.03+12

This commit introduces a significant shift in the repository structure by replacing the Parse Server implementations with Firebase-based repositories. It also adds a new Cloud Function to retrieve boardgame names and integrates new utility methods to enhance error handling and repository consistency.

### Changes made:

1. **go-functions/function.go**:
   - Added `GetBoardgameNames` Cloud Function to retrieve boardgame data.
   - Introduced a new `BGNameModel` struct for summarized boardgame data.
   - Renamed `ChangeUserRoleClaim` to `ChangeUserRole` for better clarity.
   - Improved error logging and handling across various functions.

2. **lib/core/models/boardgame.dart**:
   - Added `toMap` and `fromMap` methods to facilitate serialization and deserialization of `BoardgameModel`.

3. **lib/data_managers/boardgames_manager.dart**:
   - Updated `add` method to use `FbBoardgameRepository`.
   - Changed `getBoardgameId` to align with updated repository methods.

4. **lib/get_it.dart**:
   - Replaced `PSBoardgameRepository` with `FbBoardgameRepository` in dependency injection setup.

5. **lib/repository/data/firebase/common/errors_codes.dart**:
   - Added new error codes for missing mechanics and boardgames.

6. **lib/repository/data/firebase/common/fb_functions.dart**:
   - Added `getBoardgameNames` method for Cloud Function integration.
   - Refactored existing methods to return `DataResult` for consistent error handling.

7. **lib/repository/data/firebase/fb_boardgame_repository.dart**:
   - Introduced a new Firebase-based repository for boardgames.
   - Implemented methods for CRUD operations and fetching boardgame names.

8. **lib/repository/data/firebase/fb_mechanic_repository.dart**:
   - Added error handling for missing mechanics in `get` method.
   - Fixed incorrect error handling in the `update` method.

9. **lib/repository/data/interfaces/i_boardgame_repository.dart**:
   - Renamed `save` method to `add` for consistency.
   - Updated `getById` to `get`.

10. **lib/repository/data/parse_server/ps_address_repository.dart**:
    - Deleted the Parse Server implementation for address management.

11. **lib/repository/data/parse_server/ps_boardgame_repository.dart**:
    - Refactored methods to align with the Firebase-based repository structure.
    - Replaced `save` with `add` and `getById` with `get`.

12. **lib/repository/data/parse_server/ps_favorite_repository.dart**:
    - Removed the Parse Server implementation for favorite management.

13. **lib/repository/data/parse_server/ps_user_repository.dart**:
    - Deleted the Parse Server implementation for user management.

### Conclusion:

These changes transition the codebase from Parse Server to Firebase, simplifying the integration and enhancing scalability. The addition of utility functions and improved error handling ensures better maintainability and clarity across the repositories. The new Cloud Function for fetching boardgame names further aligns the backend with modern requirements.


## 2024/12/03 - version: 0.0.03+11

This commit introduces significant improvements to the mechanics and favorites modules, migrates mechanics management to Firebase, and refactors related code for consistency and maintainability. Additionally, it modifies the database setup and adjusts constants to support the new workflow.

### Changes made:

1. **assets/data/bgBazzar.db**:
   - Removed the old database file `bgBazzar.db`.

2. **lib/core/models/address.dart**:
   - Added the `id` field to the `toMap` method to include the address ID in Firebase interactions.

3. **lib/core/models/favorite.dart**:
   - Updated the `toMap` and `fromMap` methods to handle the `id` field, ensuring compatibility with Firebase structure.

4. **lib/core/models/mechanic.dart**:
   - Marked `id`, `name`, and `description` fields as `final` for immutability.

5. **lib/data_managers/addresses_manager.dart**:
   - Replaced `getUserAddresses` with `getAll` for compatibility with Firebase repositories.

6. **lib/data_managers/mechanics_manager.dart**:
   - Refactored the mechanics update process to integrate with Firebase.
   - Added a new `updateWithCSV` method to support importing mechanics data from CSV files.
   - Improved error handling and streamlined logic for updating mechanics locally and in Firebase.

7. **lib/features/account/mechanics/mechanics_controller.dart**:
   - Added the `importCSV` method to facilitate CSV imports for mechanics management.

8. **lib/features/account/mechanics/mechanics_screen.dart**:
   - Integrated a CSV import button to trigger the `_importCSV` method.

9. **lib/features/account/mechanics/widgets/mach_floating_action_button.dart**:
   - Added a new FloatingActionButton for CSV imports, with appropriate tooltip and icon.

10. **lib/get_it.dart**:
    - Replaced `PSMechanicsRepository` with `FbMechanicRepository` in dependency injection.
    - Updated other references to reflect the migration to Firebase.

11. **lib/repository/data/firebase/fb_address_repository.dart**:
    - Refactored methods to exclude the `id` field from the database document during updates and inserts.

12. **lib/repository/data/firebase/fb_favorite_repository.dart**:
    - Adjusted methods to handle the `id` field consistently with Firebase operations.

13. **lib/repository/data/firebase/fb_mechanic_repository.dart** (new file):
    - Implemented a Firebase-based repository for managing mechanics, including methods for CRUD operations.

14. **lib/repository/data/interfaces/i_address_repository.dart**:
    - Replaced `getUserAddresses` with `getAll` to align with the updated repository interface.

15. **lib/repository/data/interfaces/i_mechanic_repository.dart**:
    - Updated method signatures and comments to reflect the migration to Firebase.

16. **lib/repository/data/parse_server/ps_mechanics_repository.dart**:
    - Removed the Parse Server implementation for managing mechanics.

17. **lib/store/constants/constants.dart**:
    - Renamed `dbName` from `bgBazzar.db` to `boards.db`.

18. **lib/store/constants/sql_create_table.dart**:
    - Changed the mechanics table schema to use `TEXT` for the primary key instead of `INTEGER`.

19. **lib/store/database/database_manager.dart**:
    - Commented out the code for copying the default database file during initialization.

20. **pubspec.yaml**:
    - Updated the assets configuration to include only the `data/` directory.

### Conclusion:

This update completes the migration of mechanics management to Firebase and enhances the functionality of the mechanics module, including support for CSV imports. It also improves consistency in database operations and prepares the project for more scalable data management.


## 2024/12/03 - version: 0.0.02+10

This commit refactors the `Favorites` module, migrating from the Parse Server to Firebase for managing favorites. It also improves naming consistency and enhances error handling in multiple classes and repositories.

### Changes made:

1. **lib/core/models/favorite.dart**:
   - Updated `FavoriteModel` to include a `userId` field.
   - Marked `id` as `final` and added a `copyWith` method for easier object mutation.
   - Introduced `toMap` and `fromMap` methods for Firebase integration.
   - Added `toString` method for better debugging.

2. **lib/data_managers/ad_manager.dart → lib/data_managers/ads_manager.dart**:
   - Renamed `AdManager` to `AdsManager` for naming consistency.

3. **lib/data_managers/bag_manager.dart**:
   - Updated references to `AdsManager` after renaming.

4. **lib/data_managers/favorites_manager.dart**:
   - Updated `FavoritesManager` to use `FbFavoriteRepository` instead of `PSFavoriteRepository`.
   - Refactored the logic for retrieving and managing favorites to accommodate Firebase structure.
   - Removed unused `_favIds` list and replaced it with dynamic mapping logic.
   - Improved error handling and logging during favorite addition and deletion.

5. **lib/features/bag/bag_controller.dart**:
   - Updated `adManager` reference to use `AdsManager`.

6. **lib/features/favorites/favorites_controller.dart**:
   - Updated `adManager` reference to use `AdsManager`.

7. **lib/features/shop/shop_controller.dart**:
   - Updated `adManager` reference to use `AdsManager`.

8. **lib/get_it.dart**:
   - Updated dependency injection to register `AdsManager` and `FbFavoriteRepository`.
   - Removed references to `PSFavoriteRepository`.

9. **lib/repository/data/firebase/fb_address_repository.dart**:
   - Corrected method references to use `_addresesCollection` instead of `addresesCollection`.
   - Enhanced encapsulation by making `_addresesCollection` private.

10. **lib/repository/data/firebase/fb_favorite_repository.dart** (new file):
    - Implemented Firebase-based repository for managing favorites, replacing Parse Server.
    - Added methods for adding, deleting, and retrieving favorites with robust error handling.

11. **lib/repository/data/interfaces/i_favorite_repository.dart**:
    - Updated interface methods to align with Firebase implementation.
    - Added `initialize`, `add`, `delete`, and `getAll` methods with updated signatures.

12. **lib/repository/data/parse_server/common/parse_to_model.dart**:
    - Updated `FavoriteModel` conversion to include the `userId` field.

13. **lib/repository/data/parse_server/ps_favorite_repository.dart**:
    - Commented out Parse Server implementation for managing favorites as it is no longer in use.

### Conclusion:

This update transitions the `Favorites` module to Firebase, aligning with the project's broader migration strategy. It also enhances consistency across naming conventions and strengthens error handling mechanisms. The introduction of `FbFavoriteRepository` simplifies operations and improves scalability for managing favorites.


## 2024/12/02 - version: 0.0.02+09

This commit implements extensive updates to the address management system, Cloud Functions, and Firebase integration. Key changes include improving the address selection functionality, enhancing Cloud Functions for managing user roles, and aligning Firestore rules with security best practices.

### Changes made:

1. **Makefile**:
   - Modified `go_functions_deploy` to use a dynamic `FUNC_NAME` variable for deploying Cloud Functions.

2. **firestore.rules**:
   - Updated Firestore rules to allow users to manage their own documents securely.
   - Restricted the ability to update the `role` field to administrators only.

3. **go-functions/function.go**:
   - Renamed `AddUserRoleClaim` function to `AssignDefaultUserRole` for better naming consistency.
   - Added `ChangeUserRoleClaim` to enable administrators to update user roles.
   - Improved error handling and token validation logic.
   - Introduced helper methods for decoding requests, verifying admin roles, and setting user roles.

4. **lib/core/singletons/current_user.dart**:
   - Added logging for debugging user data during initialization.

5. **lib/data_managers/addresses_manager.dart**:
   - Introduced `selectedAddress` and `selectedIndex` getters to manage the currently selected address.
   - Added `selectIndex` method to update the selected address index and toggle selection status.

6. **lib/features/addresses/addresses_controller.dart**:
   - Simplified address selection logic using indices.
   - Ensured proper initialization of the selected index.

7. **lib/features/addresses/addresses_screen.dart**:
   - Updated the UI to reflect the selected address dynamically.

8. **lib/main.dart**:
   - Adjusted Firebase emulator initialization for production and development environments.
   - Removed redundant initialization calls for cleaner setup.

9. **lib/repository/data/firebase/common/fb_functions.dart**:
   - Renamed `addUserRoleClaim` to `assignDefaultUserRole`.
   - Improved error handling for assigning default user roles.

10. **lib/repository/data/firebase/fb_user_repository.dart**:
    - Added functionality to refresh ID tokens and retrieve custom claims.
    - Updated calls to the renamed Cloud Function.

11. **lib/repository/data/interfaces/i_address_repository.dart**:
    - Updated the `initialize` method to accept nullable user IDs for flexibility.

### Conclusion:

This commit enhances security, maintainability, and functionality across multiple modules. The updated address management system supports dynamic selection, while Firestore rules and Cloud Functions ensure better compliance with security standards. These changes provide a robust foundation for future development and scalability.


## 2024/12/02 - version: 0.0.02+08

This commit introduces a wide range of enhancements, including the addition of custom fonts, a new splash page implementation, and improvements in the address and user repository logic. Key updates focus on improving the user experience, modularizing code, and introducing error handling for better debugging and maintenance.

### Changes made:

1. **assets/fonts/Comfortaa-Bold.ttf**, **assets/fonts/Comfortaa-Light.ttf**, **assets/fonts/Comfortaa-Medium.ttf**, **assets/fonts/Comfortaa-Regular.ttf**, **assets/fonts/Comfortaa-SemiBold.ttf**:
   - Added font files for the "Comfortaa" font family with multiple weights (300 to 700) to enhance typography.

2. **assets/images/boards_splash.png**:
   - Added a new splash image to represent the branding on the splash screen.

3. **lib/app.dart**:
   - Updated the `initialRoute` to point to `SplashPageScreen`.
   - Added the route for `SplashPageScreen` to the application's route map.

4. **lib/core/models/address.dart**:
   - Introduced a new `selected` property in `AddressModel` with a default value of `false`.
   - Updated `copyWith`, `toMap`, and `fromMap` methods to include the `selected` property.
   - Removed unused methods and redundant overrides for `==` and `hashCode`.

5. **lib/core/singletons/app_settings.dart**:
   - Ensured initialization of `prefs` in the `init` method.

6. **lib/core/singletons/current_user.dart**:
   - Renamed `init` method to `initialize` for better semantic clarity.

7. **lib/core/theme/app_text_style.dart**:
   - Added new `TextStyle` definitions for the "Comfortaa" font family with various font weights.

8. **lib/data_managers/addresses_manager.dart**:
   - Modified the `save` method to automatically select the first address if no addresses exist.
   - Ensured initialization of the address repository with the user ID during login.

9. **lib/features/splash/splash_page_controller.dart** (new file):
   - Added a controller for the splash page to handle initialization tasks such as caching data and verifying user sessions.

10. **lib/features/splash/splash_page_screen.dart** (new file):
    - Implemented a splash screen with a loading animation and navigation to the main shop screen.

11. **lib/features/splash/splash_page_store.dart** (new file):
    - Created a store to manage the state of the splash screen.

12. **lib/get_it.dart**:
    - Updated the dependency injection setup to register singletons consistently for managers.

13. **lib/main.dart**:
    - Streamlined initialization logic by relying on `DatabaseProvider.initialize` for sequential setup.

14. **lib/repository/data/firebase/common/errors_codes.dart** (new file):
    - Added a centralized error code class for consistent error handling across the application.

15. **lib/repository/data/firebase/fb_address_repository.dart**:
    - Introduced user ID validation and error handling using the new error codes.
    - Added initialization logic for user ID.

16. **lib/repository/data/firebase/fb_user_repository.dart**:
    - Updated error handling to use the new centralized error codes.

17. **lib/repository/data/interfaces/i_address_repository.dart**:
    - Added a new `initialize` method for setting up user-specific configurations.

18. **pubspec.yaml**:
    - Added font configurations for the "Comfortaa" font family.

### Conclusion:

These updates significantly enhance the application's usability and maintainability by introducing custom fonts, a new splash screen, and robust error handling. The improved modularization and initialization logic lay a strong foundation for future development while providing a better user experience.


## 2024/12/01 - version: 0.0.02+07

This commit introduces several refinements and enhancements across the address management system, including adjustments in model definitions, repository logic, and controller methods. Key improvements involve removing redundant properties, adding a new `update` method to the address repository, and ensuring a better alignment with Firebase's user-specific collections.

### Changes made:

1. **lib/core/models/address.dart**:
   - Changed all properties to `final` for immutability.
   - Removed the `ownerId` property as it is no longer needed.
   - Added a new `selected` property with a default value of `false`.
   - Adjusted the `copyWith` method to reflect property changes.
   - Updated the `toMap` and `fromMap` methods to exclude `ownerId`.

2. **lib/data_managers/addresses_manager.dart**:
   - Renamed `getFromUserId` to `getAddresesesFromUserId` for clarity.
   - Updated `save` method logic to manage updates and new address additions based on `id` and `name` checks.
   - Added logic to differentiate between address creation and updates using repository methods.

3. **lib/features/addresses/edit_address/edit_address_controller.dart**:
   - Removed the `ownerId` assignment when creating a new `AddressModel`.

4. **lib/repository/data/firebase/fb_address_repository.dart**:
   - Updated the repository to use Firebase subcollections under `users` for addresses.
   - Introduced a new `update` method to handle updates to existing addresses.
   - Removed the use of `ownerId` in queries and adapted methods to use the current user's ID.

5. **lib/repository/data/interfaces/i_address_repository.dart**:
   - Added a declaration for the new `update` method.
   - Simplified the `getUserAddresses` method by removing the `userId` parameter.

6. **lib/repository/data/parse_server/common/parse_to_model.dart**:
   - Removed the mapping of the `ownerId` property from Parse objects to `AddressModel`.

7. **lib/repository/data/firebase/fb_user_repository.dart**:
   - Fixed a bug where `isPhoneVerified` logic was incorrectly applied.

### Conclusion:

These updates improve the maintainability, scalability, and correctness of the address management module. By aligning the address repository logic with user-specific collections and removing redundant properties, the code becomes cleaner and more robust. Additionally, the new `update` method ensures seamless address modifications, supporting future extensibility.


## 2024/11/30 - version: 0.0.02+06

This commit focuses on refactoring existing Firebase repository code and implementing new functionalities to enhance modularity, reusability, and error handling in Firebase and other associated components. The updates are divided across multiple key files, each with a series of well-thought-out modifications and improvements.

### Changes Made:

1. **lib/core/models/address.dart**:
   - Renamed `userId` to `ownerId` throughout the `AddressModel` class for more accurate representation of ownership of addresses.
   - Updated `toString()`, `== operator`, `hashCode`, `copyWith`, `toMap`, and `fromMap` methods to use `ownerId` instead of `userId`.

2. **lib/core/models/user.dart**:
   - Added `isEmailVerified` and `isPhoneVerified` properties to enhance tracking of user's verification status.
   - Updated the `toString()` and `copyWith()` methods to include these new fields.

3. **lib/data_managers/addresses_manager.dart**:
   - Updated `getFromUserId`, `deleteByName`, and `deleteById` methods to handle new `DataResult` error-checking responses before accessing the data.
   - Enhanced the `addOrUpdateAddress` method to handle possible errors returned by the repository.

4. **lib/features/addresses/edit_address/edit_address_controller.dart**:
   - Renamed `userId` to `ownerId` to be consistent with changes made in the `AddressModel` class.

5. **lib/features/signin/signin_controller.dart**:
   - Refactored the `login` method to return a simple `bool` instead of using a `DataResult` wrapper, simplifying its usage for other components.
   - Added specific error messages for different error codes to improve the user experience during login.

6. **lib/features/signin/signin_screen.dart**:
   - Updated `_userLogin` to use the new `bool` return type from `login()`, simplifying success checking.

7. **lib/get_it.dart**:
   - Updated `IAddressRepository` registration to use `FbAddressRepository` instead of the deprecated `PSAddressRepository`.

8. **lib/repository/data/firebase/fb_address_repository.dart** (New File):
   - Created a new Firebase implementation of the `IAddressRepository`, named `FbAddressRepository`.
   - Added methods for `add`, `delete`, and `getUserAddresses` with appropriate error handling using the `DataFunctions` utility.

9. **lib/repository/data/firebase/fb_user_repository.dart**:
   - Introduced constants to manage error codes.
   - Enhanced error handling for email verification during sign-in.
   - Added functions to store and validate user data (`_signInUsers` and `_signUpUsers`).
   - Restructured existing methods (`signInWithEmail`, `signUp`, `signOut`) to better modularize the logic and error-checking flow.

10. **lib/repository/data/functions/data_functions.dart** (New File):
    - Created a utility class named `DataFunctions` to handle common error handling logic, improving the consistency and maintainability of error handling across Firebase repository classes.

11. **lib/repository/data/interfaces/i_address_repository.dart**:
    - Updated `IAddressRepository` interface to return `DataResult` types for all methods, providing a consistent way to handle success and failure scenarios.

12. **lib/repository/data/parse_server/common/parse_to_model.dart**:
    - Updated `userId` to `ownerId` in the `ParseToModel` conversion method.

13. **lib/repository/data/parse_server/ps_address_repository.dart** & **lib/repository/data/parse_server/ps_user_repository.dart**:
    - Commented out the old Parse Server implementation (`PSAddressRepository`, `PSUserRepository`) to reduce confusion and indicate migration to the Firebase-based repository.

### Conclusion:

These changes aim to enhance the flexibility, reusability, and maintainability of the repository layer, making it easier to manage and extend Firebase functionalities. The introduction of the `FbAddressRepository` as well as better error handling across various methods ensures a more robust solution for address and user management in the application.


## 2024/11/29 - version: 0.0.01+05

This commit introduces significant updates to the Firebase Cloud Functions and repository structure, adding new methods for role management, verification email handling, and user password features. The changes also include improvements in error handling, restructuring of existing methods, and introduction of new utility functions for better modularization.

### Changes made:

1. **README.md**:
   - Corrected a header from "#### **Files Modified and Details**" to "### **Files Modified and Details**" for consistent styling.

2. **go-functions/function.go**:
   - Added SMTP setup and verification email sending functionality.
   - Introduced `SendVerificationEmail` HTTP function and updated the `AddUserRoleClaim` to be callable.
   - Updated payload handling for Cloud Functions to support nested data.
   - Enhanced response handling for both `AddUserRoleClaim` and `SendVerificationEmail` functions.
   - Improved logging and error handling throughout the code.

3. **go-functions/go.mod**:
   - Added new dependencies including `github.com/GoogleCloudPlatform/functions-framework-go`, `github.com/json-iterator/go`, and `go.uber.org/zap`.
   - Updated the version of several indirect dependencies to support the new features.

4. **go-functions/go.sum**:
   - Updated with checksums for newly added dependencies.

5. **lib/features/signin/signin_screen.dart**:
   - Removed unused import (`or_row.dart`).
   - Commented out Facebook login button and the separator row (`OrRow`) as these functionalities have not been implemented yet.

6. **lib/repository/data/firebase/fb_user_repository.dart**:
   - Removed the in-file method `_addUserRoleClaim` and created a new utility class `FbFunctions` for Firebase function calls.
   - Refactored `signUp` method to include email verification and update the handling of role claims using `FbFunctions`.
   - Added new methods for password reset (`requestResetPassword`) and phone verification management (`submitPhoneVerificationCode`).
   - Removed redundant code related to user role claims and password management, consolidating responsibilities.

7. **lib/repository/data/firebase/functions/fb_functions.dart** (New file):
   - Created a utility class `FbFunctions` to handle Cloud Functions calls for Firebase.
   - Added methods `addUserRoleClaim` and `sendVerificationEmail` to modularize function calls, improve reusability, and centralize error handling.

### Conclusion:

These updates enhance modularity by centralizing Firebase function interactions within a dedicated utility class. The improvements to error handling, restructuring of the `signUp` workflow, and the addition of new methods make the repository more maintainable and scalable. Additionally, email verification and custom claim management have been streamlined, improving the overall reliability of user management features.


## 2024/11/29 - version: 0.0.01+04

This commit introduces changes and enhancements to the Go-based Firebase functions for managing user roles, local testing, and dependencies. Below is a detailed breakdown of the modifications:

### **Files Modified and Details**

1. **`.gcloudignore`**  
   - Added a new file to exclude the `go-tests/` directory from being uploaded to Google Cloud.  

     ```txt
     # Exclude local test directory
     go-tests/
     ```

2. **`Makefile`**  
   - Removed the GPL license header for brevity.  
   - Updated targets for Firebase emulator commands and added new deployment commands for Go functions:
     - `firebase_emu_stop`: Added a script to stop the emulator.
     - `go_functions_deploy`: Added a deployment command for Go-based Firebase functions.
   - Commented out previously defined Firebase emulator targets (`firebase_emu`, `firebase_emu_debug`, `firebase_functions_deploy`).

3. **Removed Old Go Functions Directory**  
   - Deleted the `functions-go` directory, including:
     - `add_role.go`: Previously handled HTTP requests to assign custom user roles.
     - `firebase_init.go`: Initialized Firebase for the functions.
     - Supporting files such as `go.mod`, `go.sum`, and `main.go`.

4. **Created New Go Functions in `go-functions` Directory**  
   - Reorganized and refactored the Firebase functions:
     - Moved the code for setting custom claims to the new `go-functions/function.go`.
     - Simplified the logic and updated the Firebase initialization.
     - Added structured logging for better debugging and insights during execution.
     - Introduced a cleaner `go.mod` file with updated dependencies.
     - Added detailed comments in the code to improve readability and maintainability.

5. **Introduced Local Testing for Functions**  
   - Added a `go-tests` directory to house local tests for the functions:
     - Created `functions/function.go` for testing role assignment locally.
     - Configured a new `go.mod` file for managing dependencies in tests.
     - Added `go.sum` for dependency resolution.

#### **Key Improvements**
- The Go functions were reorganized into a new directory structure for better maintainability.
- Updated Firebase initialization to remove the reliance on hardcoded credentials.
- Enhanced modularization and removed redundant or outdated dependencies.
- Introduced local testing infrastructure for efficient debugging without deploying to production.

### Conclusion

These changes provide a more streamlined structure for the Go-based Firebase functions, improving their clarity, maintainability, and testability.


## 2024/11/28 - version: 0.0.01+03

This commit introduces several updates and refactors, including Firebase integration enhancements, new repositories, and adjustments for modularized user management.

### **Changes**
1. **`.gitignore`**
   - Added `+/emulator_data` for excluding Firebase emulator cache data.
   
2. **`Makefile`**
   - Added `firebase_emu`, `firebase_emu_debug`, `firebase_emusavecache`, and `firebase_functions_deploy` tasks for Firebase emulators and deployment management.

3. **`AndroidManifest.xml`**
   - Introduced `android:usesCleartextTraffic="true"` for Firebase emulator compatibility. *(FIXME: Change to `false` in production).*

4. **`firebase.json`**
   - Changed `functions` source from `functions` to `functions-go` to align with the transition to Go-based Firebase functions.

5. **`functions-go`**
   - Created a new folder structure for Firebase Cloud Functions using Go:
     - **`add_role.go`**: Implements the function to add a custom user role.
     - **`firebase_init.go`**: Initializes Firebase Auth client with the provided credentials.
     - **`main.go`**: Entry point to register the HTTP function and start the server.
     - **`go.mod` and `go.sum`**: Configured Go module dependencies for Firebase and related libraries.

6. **Removed `functions` (Node.js-based implementation)**
   - Deleted the following files:
     - `functions/.eslintrc.js`
     - `functions/.gitignore`
     - `functions/index.js`
     - `functions/package-lock.json`
     - `functions/package.json`

7. **Flutter Integration**
   - **`lib/features/account/my_data/my_data_controller.dart`**
     - Updated `update` method to `updatePassword` for clarity.
   - **`lib/features/signin/signin_controller.dart`**
     - Renamed `resetPassword` to `requestResetPassword` for explicit context.

   - **`lib/main.dart`**
     - Added Firebase emulator configuration for authentication, Firestore, and Cloud Functions when in `kDebugMode`.
     - Logged emulator usage for debugging.

8. **Dependency Injection**
   - **`lib/get_it.dart`**
     - Replaced `PSUserRepository` with `FbUserRepository` for Firebase compatibility.

9. **Repositories**
   - **`FbUserRepository`**: New Firebase-based user repository added in `lib/repository/data/firebase`.
     - Handles user authentication, email sign-in, password reset, and phone verification.
     - Introduced modular methods with detailed error handling and Firebase Auth integration.
   - **`i_user_repository.dart`**
     - Added `PhoneVerificationInfo` model for structured phone verification data.
     - Enhanced documentation for clarity and maintainability.

### **Conclusion**
This commit refactors the Firebase integration and user management structure to align with modular principles and introduces support for Firebase emulators in development. Future changes will include addressing production-specific configurations like `CleartextTraffic`.


## 2024/11/27 - version: 0.0.01+02

### Integrating Firebase configuration and functionality to the project.

This commit introduces the Firebase setup, including necessary files, dependencies, and configurations to enable Firebase services in the project. Key additions include Firebase core, authentication support, Firestore rules, and FlutterFire setup.

### Changes made:

1. **`.firebaserc`**:
   - Added the Firebase project configuration with the default project set to `boards-fc3e5`.

2. **`.gitignore`**:
   - Ignored the `google-services.json` file to prevent sensitive information from being exposed.

3. **`android/app/build.gradle`**:
   - Included the `com.google.gms.google-services` plugin for Firebase.
   - Adjusted SDK versions to match Firebase requirements (`minSdk = 23`, `targetSdk = 34`).
   - Configured release signing using the `key.properties` file.

4. **`android/settings.gradle`**:
   - Added the `com.google.gms.google-services` plugin setup.

5. **`firebase.json`**:
   - Added Firebase platform configurations, including Android app credentials, Firestore, and storage emulators.

6. **`firestore.indexes.json`**:
   - Created an empty indexes file for Firestore.

7. **`firestore.rules`**:
   - Added default Firestore rules allowing unrestricted access until December 27, 2024.

8. **`functions/.eslintrc.js`**:
   - Configured ESLint rules for the Firebase functions directory.

9. **`functions/.gitignore`**:
   - Added ignore rules for `node_modules` and local files in the Firebase functions directory.

10. **`functions/index.js`**:
    - Added a placeholder for Firebase functions with an example setup.

11. **`functions/package-lock.json` & `functions/package.json`**:
    - Configured Node.js dependencies for Firebase functions, including `firebase-admin` and `firebase-functions`.

12. **`lib/firebase_options.dart`**:
    - Generated Firebase options file for platform-specific configurations using the FlutterFire CLI.

13. **`lib/main.dart`**:
    - Initialized Firebase and configured the authentication emulator for local development.

14. **`pubspec.lock` & `pubspec.yaml`**:
    - Added dependencies for `firebase_core` and `firebase_auth` to support Firebase services in the Flutter application.

15. **`storage.rules`**:
    - Added default Firebase Storage rules denying all read and write operations.

### Conclusion:

These changes establish a solid Firebase foundation, enabling core functionalities like authentication, Firestore, and storage management. This integration provides a seamless path for future enhancements, such as adding Firebase functions and advanced database security rules.


## 2024/11/27 - version: 0.0.01+01

This commit includes major updates to rebrand the application from `bgbazzar` to `boards`, impacting namespaces, identifiers, and test imports. It also updates dependencies in the `pubspec.lock` file and resolves minor import issues for consistency.

### Changes made:

1. **android/app/build.gradle**:
   - Changed `namespace` and `applicationId` from `br.dev.rralves.bgbazzar` to `br.dev.rralves.boards`.

2. **android/app/src/main/AndroidManifest.xml**:
   - Updated the app label from `bgbazzar` to `boards`.

3. **ios/Runner/Info.plist**:
   - Renamed `CFBundleDisplayName` and `CFBundleName` from `Bgbazzar` to `Boards`.

4. **lib/features/chat/chat_store.dart**:
   - Adjusted import paths to replace `bgbazzar` with `boards`.

5. **lib/features/edit_ad/edit_ad_form/edit_ad_form.dart**:
   - Updated the import path for `spin_box_field.dart` to use the relative path.

6. **lib/features/payment/payment_screen.dart**:
   - Updated the import path for `state_error_message.dart` to use the relative path.

7. **pubspec.lock**:
   - Updated multiple dependencies to their latest versions for better stability and performance.

8. **pubspec.yaml**:
   - Changed the app name from `bgbazzar` to `boards`.

9. **test/common/abstracts/data_result_test.dart**:
   - Updated the import path to reflect the new namespace (`boards`).

10. **test/common/utils/utils_test.dart**:
    - Adjusted the import path to reflect the rebranding to `boards`.

11. **test/repository/ibge_repository_test.dart**:
    - Replaced the `bgbazzar` import path with `boards`.

### Pending work:
   - Test all critical features to ensure no runtime issues due to namespace changes.
   - Verify proper integration of updated dependencies.
   - Update documentation and release notes to reflect the rebranding.

### Conclusion

This commit completes the rebranding of the application to `boards` and updates dependency versions. While these changes align the codebase with the new branding, thorough testing is required to confirm stability and resolve any lingering issues.


## 2024/11/25 - version: 0.7.20+94

This commit updates the `SearchDialog` widget by replacing the `ShopController` dependency with `SearchFilter`, ensuring a cleaner and more modular implementation for managing search filters. However, the bug related to filter state inconsistencies is not fully resolved. Further testing and review are required to address all edge cases.

### Changes made:

1. **lib/features/shop/widgets/search/search_dialog.dart**:
   - Removed the `ShopController` dependency and replaced it with `SearchFilter`.
   - Updated the `_filterSearch` method to use `SearchFilter` for managing filters.
   - Modified the `_filterClean` method to reset the filters using `SearchFilter`.
   - Adjusted `ListenableBuilder` and filter comparison logic to work with `SearchFilter`.

### Pending work:
   - Investigate potential issues with filter state updates not reflecting correctly in the UI.
   - Test edge cases for the `_filterSearch` and `_filterClean` methods to ensure expected behavior.
   - Review integration with other components relying on `SearchFilter` to avoid regression.

### Conclusion

These changes streamline the `SearchDialog` implementation by delegating filter management to `SearchFilter`. While the update enhances modularity, the bug is not fully fixed, requiring additional testing and adjustments to ensure stability and correctness.


## 2024/11/25 - version: 0.7.20+93

This commit introduces multiple changes across the project, including enhancements in the ShopGridView component, creation of new Favorites management modules, refinements in image processing for board games, dependency registrations, and adjustments to controllers and screens for improved state management and modularity.

### Changes made:

1. **assets/data/bgBazzar.db**:
   - Updated the database binary file with changes reflecting updated data or structure.

2. **lib/components/collection_views/shop_grid_view/shop_grid_view.dart**:
   - Replaced the `ShopController` dependency with `ads` and `getMoreAds` for improved modularity.
   - Adjusted methods and properties to work with `ads` directly instead of the `ShopController`.

3. **lib/components/widgets/state_loading_message.dart**:
   - Extracted a reusable method `containerCircularProgressIndicator` for generating a loading container.
   - Updated the `build` method to use the new helper method for better code readability.

4. **lib/components/widgets/state_message.dart**:
   - Created a new widget `StateMessage` to handle various states with customizable messages, buttons, and icons.

5. **lib/core/singletons/current_user.dart**:
   - Added a guard in `init` to prevent re-initialization if the user is already logged in.

6. **lib/data_managers/boardgames_manager.dart**:
   - Enhanced image processing methods to support PNG format with the `forceJpg` parameter.
   - Renamed `_convertImageToJpg` to `_convertImage` for broader format support.
   - Improved image naming standardization logic.

7. **lib/features/favorites/favorites_controller.dart**:
   - Created a new `FavoritesController` to manage favorite items, encapsulating state and logic.

8. **lib/features/favorites/favorites_screen.dart**:
   - Integrated the new `FavoritesController` and `FavoritesStore` for managing favorites state and UI.
   - Improved state handling using `StateMessage` and `ListenableBuilder`.

9. **lib/features/favorites/favorites_store.dart**:
   - Added a new `FavoritesStore` extending `StateStore` to manage favorites state.

10. **lib/features/payment/payment_controller.dart**:
    - Updated `init` and `_initializeController` to include `BuildContext` as a parameter for better context handling.

11. **lib/features/payment/payment_screen.dart**:
    - Passed `BuildContext` to the `PaymentController` during initialization.

12. **lib/features/shop/shop_controller.dart**:
    - Removed deprecated methods `_getAds` and `_getMoreAds` to streamline the code.

13. **lib/features/shop/shop_screen.dart**:
    - Adjusted `ShopGridView` initialization to pass `ads` and `getMoreAds` instead of `ctrl`.

14. **lib/get_it.dart**:
    - Registered `BagItemStore` as an asynchronous dependency in `GetIt`.

15. **lib/repository/data/parse_server/ps_boardgame_repository.dart**:
    - Reorganized method calls for better logical flow during board game updates.

16. **lib/repository/local_data/sqlite/bag_item_repository.dart**:
    - Switched to using `GetIt` for resolving `BagItemStore` dependency.

### Conclusion

These updates enhance the modularity, readability, and maintainability of the project. New modules for managing favorites improve separation of concerns, while changes to ShopGridView streamline its use. Additional refinements in image processing and dependency management ensure greater flexibility and adherence to best practices.


## 2024/11/25 - version: 0.7.19+92

This commit introduces a robust payment integration flow by transitioning from `PaymentPage` to `PaymentScreen`, updating related logic and services, and enhancing the payment brick functionality. Key improvements include refined method signatures, enhanced error handling, and streamlined parameter passing.

### Changes made:

1. **lib/app.dart**:
   - Renamed `PaymentPage` to `PaymentScreen` for better consistency.
   - Updated route logic to include `amount` as an additional parameter for `PaymentScreen`.

2. **lib/core/models/bag_item.dart**:
   - Added the `toMPParameter` method to transform `BagItemModel` into the format expected by the payment service.

3. **lib/features/bag/bag_controller.dart**:
   - Added `getPreferenceId` method for obtaining the payment preference ID via `PaymentService`.
   - Added `calculateAmount` method to compute the total amount for a list of items.

4. **lib/features/bag/bag_screen.dart**:
   - Integrated the `_makePayment` method to handle the payment process and navigate to `PaymentScreen`.
   - Updated UI logic to pass `preferenceId` and `amount` as arguments for payment navigation.

5. **lib/features/bag/widgets/saller_bag.dart**:
   - Added `makePayment` parameter to trigger payment flow from the UI.
   - Updated `FilledButton` to invoke the `makePayment` method.

6. **lib/features/payment/payment_controller.dart**:
   - Updated `init` method to include `amount` alongside `preferenceId`.
   - Enhanced `_initializeController` with better error logging and URL construction to include `amount`.

7. **lib/features/payment/payment_screen.dart**:
   - Renamed from `PaymentPage` to `PaymentScreen`.
   - Updated initialization to include `amount` and improved state error messaging.

8. **lib/services/payment/payment_service.dart**:
   - Renamed `getPreferenceId` to `generatePreferenceId`.
   - Updated parameter type from `PaymentModel` to `BagItemModel` and aligned with the `toMPParameter` format.

9. **parse_server/cloud/main.js**:
   - Improved error handling and logging in the `createPaymentPreference` cloud function.
   - Dynamically retrieved the Mercado Pago access token from environment variables.

10. **parse_server/public/payment_page.html**:
    - Updated JavaScript to include `amount` in the initialization and rendered payment brick settings.
    - Enhanced error logging for payment brick rendering.

### Conclusion:
These updates significantly improve the payment integration process, ensuring a seamless user experience with robust error handling and better parameter management. The transition to `PaymentScreen` enhances modularity and maintainability across the payment flow.


## 2024/11/25 - version: 0.7.18+91

This commit enhances the handling of item quantities in the shopping bag, focusing on improving the `BagItemModel`, updating the bag management logic, and integrating new database methods for item quantity updates. Key changes include a new `updateQuantity` method, refactored quantity management, and alignment across the data layer.

### Changes made:

1. **lib/core/models/bag_item.dart**:
   - Refactored `quantity` to a public field for improved access.
   - Modified `increaseQt` and `decreaseQt` methods to return a boolean indicating success or failure.
   - Updated `toString` and other methods to reflect the changes in `quantity`.

2. **lib/data_managers/ad_manager.dart**:
   - Added documentation for the `getAdById` method to clarify its purpose.

3. **lib/data_managers/bag_manager.dart**:
   - Introduced `_loadItems` to initialize bag items and synchronize them with the latest ad statuses and quantities.
   - Refined `addItem`, `increaseQt`, and `decreaseQt` to handle item quantity updates more effectively.
   - Enhanced `_updateCountValue` to dynamically adjust the overall item count.
   - Added comprehensive documentation for key methods.

4. **lib/repository/local_data/interfaces/i_local_bag_item_repository.dart**:
   - Added the `updateQuantity` method to the repository interface for direct quantity updates.

5. **lib/repository/local_data/sqlite/bag_item_repository.dart**:
   - Implemented the `updateQuantity` method to handle quantity updates in the SQLite database.

6. **lib/store/stores/bag_item_store.dart**:
   - Added `updateQuantity` for efficient updates of item quantities in the local database.
   - Enhanced `add` and `update` methods with explicit `where` clauses to improve safety and clarity.

7. **lib/store/stores/interfaces/i_bag_item_store.dart**:
   - Introduced the `updateQuantity` method in the store interface for consistent implementation.

### Conclusion:

These updates streamline the management of item quantities within the shopping bag. The new `updateQuantity` method ensures efficient and reliable synchronization between the app's state and the local database. Refined methods and enhanced documentation improve maintainability, setting the stage for future enhancements.


## 2024/11/23 - version: 0.7.17+90

This commit introduces a comprehensive set of updates to enhance the handling of `BagItemModel` in the application. Key changes include adding a local repository for bag items, improving error handling, and integrating database functionality with SQFLite. These updates also refine existing models, repositories, and controllers to align with the new structure.

### Changes made:

1. **lib/components/collection_views/ad_list_view/widgets/ad_card_view.dart**:
   - Updated null-safe handling of `city` and `state` in `AdTextInfo`.

2. **lib/core/models/ad.dart**:
   - Removed unused static methods for converting mechanics names to IDs.
   - Added new properties (`ownerId`, `ownerName`, etc.) to the `AdModel`.
   - Updated `copyWith` and `toMap` methods to support the new properties.
   - Modified the `fromMap` method to map new fields.

3. **lib/core/models/bag_item.dart**:
   - Refactored `BagItemModel` to include private fields (`_ad`, `_ownerId`, etc.) with getters and setters.
   - Added methods to manage item relationships with ads.
   - Updated `toMap`, `fromMap`, and `copyWith` to include new fields and logic.

4. **lib/core/singletons/current_user.dart**:
   - Introduced `BagManager` integration for managing user-specific bag items.

5. **lib/data_managers/bag_manager.dart**:
   - Added full integration with a local SQLite repository.
   - Implemented initialization logic and database synchronization.
   - Enhanced methods for adding, increasing, and decreasing item quantities with database updates.

6. **lib/features/bag/widgets/saller_bag.dart**:
   - Updated references to use the refactored `BagItemModel`.

7. **lib/features/shop/product/product_controller.dart**:
   - Refactored to initialize `BagItemModel` using the new `ad` parameter.

8. **lib/get_it.dart**:
   - Registered `ILocalBagItemRepository` and its implementation, `SqliteBagItemRepository`.

9. **lib/repository/local_data/common/local_functions.dart**:
   - Added utility methods for consistent local error handling.

10. **lib/repository/local_data/interfaces/i_local_bag_item_repository.dart**:
    - Defined an interface for local bag item repository operations.

11. **lib/repository/local_data/sqlite/bag_item_repository.dart**:
    - Implemented SQLite-based repository for bag item management.

12. **lib/store/constants/constants.dart**:
    - Defined constants for the `bagItemsTable` and its fields.

13. **lib/store/constants/migration_sql_scripts.dart**:
    - Added a migration script for creating the `bagItemsTable`.

14. **lib/store/constants/sql_create_table.dart**:
    - Introduced methods for creating, dropping, and cleaning the `bagItemsTable`.

15. **lib/store/database/database_manager.dart**:
    - Integrated `bagItemsTable` creation and reset functionality.

16. **lib/store/stores/bag_item_store.dart**:
    - Implemented the SQLite storage layer for bag items.

17. **lib/store/stores/interfaces/i_bag_item_store.dart**:
    - Added an interface for the `BagItemStore`.

18. **lib/store/stores/mechanics_store.dart**:
    - Corrected a method log message for consistency.

### Conclusion:

These changes establish a robust system for managing bag items locally with SQLite, enhancing performance and scalability. They also align models, controllers, and database components with the new structure, ensuring consistency and maintainability. This update sets the foundation for future improvements in bag management features.


## 2024/11/22 - version: 0.7.17+89

This commit introduces a new `AdManager` class to centralize advertisement management, enhances the Bag module to integrate ad details dynamically, and refactors the `ShopController` to utilize `AdManager` for fetching ads. These changes improve data organization and streamline ad-related operations across the app.

### Changes made:

1. **lib/data_managers/ad_manager.dart** (New file):
   - Added a new `AdManager` class to centralize ad-related operations.
   - Implemented methods to fetch ads (`getAds` and `getMoreAds`) and retrieve ad details by ID (`getAdById`).
   - Maintains an internal list of `AdModel` instances for efficient reuse.

2. **lib/features/bag/bag_controller.dart**:
   - Integrated `AdManager` for retrieving ad details dynamically.
   - Added `getAdById` method to fetch and manage ad details via `AdManager`.

3. **lib/features/bag/bag_screen.dart**:
   - Added `_openAd` method to navigate to the `ProductScreen` using ad details fetched by `AdManager`.
   - Updated `SallerBag` widget to handle the new ad opening logic.

4. **lib/features/bag/widgets/saller_bag.dart**:
   - Refactored `SallerBag` to a stateful widget.
   - Added an `InkWell` around ad images to trigger the `_openAd` callback for navigating to the ad details screen.

5. **lib/features/shop/shop_controller.dart**:
   - Replaced direct ad fetching logic with `AdManager` methods.
   - Removed redundant methods (`_getAds` and `_getMoreAds`) for cleaner code.

6. **lib/features/shop/shop_screen.dart**:
   - Added a bag icon with a badge displaying the count of items, linking to the Bag screen.
   - Refactored the app bar for improved user interaction.

7. **lib/get_it.dart**:
   - Registered `AdManager` as a singleton in the service locator.

8. **lib/repository/data/interfaces/i_ad_repository.dart**:
   - Added `getById` method to the `IAdRepository` interface for fetching ad details by ID.

9. **lib/repository/data/parse_server/ps_ad_repository.dart**:
   - Implemented the `getById` method to query ad details from the Parse server.
   - Enhanced error handling and response validation.

### Conclusion:

These updates establish a more cohesive and maintainable structure for managing advertisements. The new `AdManager` simplifies ad-related operations and eliminates redundant code. The integration of `AdManager` with Bag and Shop modules improves efficiency and consistency across the app.


## 2024/11/22 - version: 0.7.17+88

This commit introduces significant refinements to the bag management system, including seller-based grouping, improvements to item operations, and UI enhancements for the Bag screen. The data model has also been updated to better represent advertisement details and improve flexibility.

### Changes made:

1. **lib/core/models/bag_item.dart**:
   - Added a private `_adId` field to store the advertisement ID explicitly, decoupling it from `adItem.id`.
   - Updated the constructor to initialize `_adId` using `adId` (if provided) or fallback to `adItem.id`.
   - Adjusted the `toMap` method to include `_adId` for serialization.
   - Modified `fromMap` to correctly initialize `_adId` from the serialized data.

2. **lib/data_managers/bag_manager.dart**:
   - Refactored `_items` into a private list for stricter encapsulation of Bag items.
   - Introduced `_bagBySeller`, a map grouping items by their seller ID (`ownerId`).
   - Enhanced `addItem` and `_checkSellers` to dynamically update `_bagBySeller` when items are added or removed.
   - Added `sellerName` to retrieve the name of a seller based on their ID.
   - Updated the `total` method to calculate the total price for items under a specific seller.

3. **lib/features/bag/bag_controller.dart**:
   - Modified `items` to return a filtered set of `BagItemModel` instances associated with a given seller ID.

4. **lib/features/bag/bag_screen.dart**:
   - Integrated seller-specific logic into the Bag screen, grouping items under their respective sellers using the `SallerBag` widget.
   - Adjusted the layout to dynamically display seller groups.

5. **lib/features/bag/widgets/bag_sub_total.dart**:
   - Updated to accept `length` (number of items) and `total` (total price) directly instead of relying on `ValueNotifier`.
   - Simplified rendering logic for better readability and performance.

6. **lib/features/bag/widgets/saller_bag.dart**:
   - Enhanced the `SallerBag` widget to accept `sallerId` and `sallerName` for displaying seller-specific details.
   - Improved layout with card-style design, dynamically listing items associated with the seller.
   - Incorporated `BagSubTotal` to show a subtotal for each seller’s group.

### Conclusion:

These updates significantly improve the flexibility and maintainability of the Bag module. By introducing `_adId`, the advertisement ID is now decoupled from `adItem`, providing a clearer separation of data concerns. The seller-based grouping enhances the user experience, and the refined widgets improve the Bag screen’s overall usability.


## 2024/11/21 - version: 0.7.17+86

This commit enhances the `AdModel` by integrating additional owner details, optimizes the bag management process, and introduces seller grouping functionality in the Bag module. Key changes also include refining Parse server integration and improving the `AdsSale` validation logic.

### Changes made:

1. **lib/components/collection_views/shop_grid_view/widgets/ad_shop_view.dart**:
   - Removed unnecessary `dart:math` import.
   - Updated `OwnerRating` widget to use `ownerName` and `ownerRate` instead of `owner.name` and a random integer.

2. **lib/components/collection_views/shop_grid_view/widgets/owner_rating.dart**:
   - Replaced `starts` parameter with `note` for a clearer rating representation.
   - Removed hardcoded `note` initialization inside the widget.

3. **lib/core/models/ad.dart**:
   - Added new owner-related fields: `ownerId`, `ownerName`, `ownerRate`, `ownerCity`, and `ownerCreateAt`.

4. **lib/data_managers/bag_manager.dart**:
   - Introduced `_sellerIds` to track unique seller IDs in the bag.
   - Added `_checkSellers` method to maintain the list of unique sellers dynamically.
   - Refactored logic in `addItem` and `decreaseQt` to call `_checkSellers` when items are added or removed.

5. **lib/features/bag/bag_screen.dart**:
   - Replaced inline item rendering logic with a dynamic seller-based grouping using the new `SallerBag` widget.
   - Simplified imports for consistency.

6. **lib/features/bag/widgets/saller_bag.dart** (New file):
   - Introduced `SallerBag` widget to group items by seller and display them in the Bag screen.

7. **lib/features/edit_ad/edit_ad_controller.dart**:
   - Ensured `store.ad.owner` is updated with the current user before saving an ad.

8. **lib/features/shop/product/product_screen.dart**:
   - Updated `UserCard` usage to include `ownerName`, `ownerRate`, `ownerCity`, and `ownerCreateAt`.

9. **lib/features/shop/product/widgets/user_card_product.dart**:
   - Added `rate` parameter to dynamically display the owner’s rating.
   - Adjusted address display to use a single string instead of an `AddressModel`.

10. **lib/repository/data/parse_server/common/constants.dart**:
    - Added constants for new owner fields: `keyAdOwnerId`, `keyAdOwnerName`, `keyAdOwnerRate`, `keyAdOwnerCity`, and `keyAdOwnerCreatedAt`.
    - Corrected typo in `keyAdBoardGame`.

11. **lib/repository/data/parse_server/common/parse_to_model.dart**:
    - Enhanced `ad` method to parse and populate new owner fields.
    - Added optional `full` parameter to control whether address and user details are fetched.

12. **lib/repository/data/parse_server/ps_ad_repository.dart**:
    - Updated `save` method to include new owner fields in the ad creation process.
    - Enhanced `get` method with a `full` parameter to include or exclude related objects.

13. **parse_server/cloud/main.js**:
    - Improved `AdsSale` validation logic to handle missing boardgame references more gracefully.
    - Added conditional logic to skip validation when no boardgame is referenced.

### Conclusion:

These updates significantly improve the Bag and Ads modules by introducing seller-based grouping, refining owner data integration, and enhancing the validation process. These changes also improve maintainability and prepare the codebase for more robust feature implementation.


## 2024/11/21 - version: 0.7.17+85

This commit introduces significant enhancements and restructuring within the `bgbazzar` project. It focuses on replacing the `CartManager` and `CartItemModel` with the newly implemented `BagManager` and `BagItemModel`. Additional updates include the creation of new screens and controllers for managing the shopping bag, refinements in model handling, and adjustments to address dependencies. 

### Changes made:

1. **assets/svg/Stars.svg**:
   - Updated export filename references for SVG layers to reflect new usage: `star_full`, `star_empty`, and `star_half`.
   - Added modifications to the layer display settings for improved visualization.

2. **lib/app.dart**:
   - Added the `BagScreen` route for navigation.

3. **lib/core/models/bag_item.dart**:
   - Introduced `BagItemModel` to replace the previous `CartItemModel`, with functionality to handle quantities and pricing logic.

4. **lib/core/models/cart_item.dart** (Deleted):
   - Removed the obsolete `CartItemModel`.

5. **lib/core/models/sale.dart → lib/core/models/sales.dart**:
   - Renamed file for consistency in naming conventions.
   - Replaced usage of `SaleItemModel` with `BagItemModel`.
   - Simplified item addition and removal logic in the sales model.

6. **lib/data_managers/bag_manager.dart**:
   - Introduced `BagManager` to handle shopping bag logic, replacing `CartManager`.
   - Added methods to manage bag items, quantities, and total calculations.

7. **lib/data_managers/cart_manager.dart** (Deleted):
   - Removed the obsolete `CartManager`.

8. **lib/features/account/my_ads/my_ads_controller.dart**:
   - Adjusted to use `status.name` instead of `status.index` for ad status management.

9. **lib/features/account/my_ads/widgets/my_tab_bar_view.dart**:
   - Removed commented-out, redundant code to streamline logic.

10. **lib/features/bag/bag_controller.dart**:
    - Added `BagController` for managing the shopping bag state and interaction with `BagStore` and `BagManager`.

11. **lib/features/bag/bag_screen.dart**:
    - Introduced a new `BagScreen` for displaying and managing the shopping bag.

12. **lib/features/bag/bag_store.dart**:
    - Created `BagStore` extending `StateStore` to manage the bag's state.

13. **lib/features/bag/widgets/bag_sub_total.dart**:
    - Added widget to display the bag's subtotal with item count and total price.

14. **lib/features/bag/widgets/quantity_buttons.dart**:
    - Introduced reusable quantity adjustment buttons for bag items.

15. **lib/features/shop/product/procuct_store.dart**:
    - Added `ProcuctStore` for state management within product-related operations.

16. **lib/features/shop/product/product_controller.dart**:
    - Created `ProductController` to handle product interactions, including adding items to the bag.

17. **lib/features/shop/product/product_screen.dart**:
    - Integrated the new bag functionality, including navigation to the `BagScreen` and adding items to the bag.

18. **lib/features/shop/product/widgets/description_product.dart**:
    - Enhanced styling for the product description section.

19. **lib/features/shop/product/widgets/location_product.dart** (Deleted):
    - Removed unused `LocationProduct` widget.

20. **lib/features/shop/product/widgets/sub_title_product.dart**:
    - Improved subtitle styling with bold text.

21. **lib/features/shop/product/widgets/title_product.dart**:
    - Adjusted title styling for better visibility.

22. **lib/features/shop/product/widgets/user_card_product.dart**:
    - Added user location and star rating display for enhanced user interaction.

23. **lib/get_it.dart**:
    - Replaced `CartManager` registration with `BagManager`.
    - Ensured proper disposal of `BagManager`.

24. **lib/repository/data/interfaces/i_ad_repository.dart**:
    - Updated method parameters to use string-based statuses instead of integers.

25. **lib/repository/data/parse_server/common/parse_to_model.dart**:
    - Adjusted status handling to use string values instead of indices.

26. **lib/repository/data/parse_server/ps_ad_repository.dart**:
    - Updated ad status and condition handling to use `name` instead of `index`.

27. **parse_server/cloud/main.js**:
    - Added logic to skip restrictions when using the MasterKey for specific cloud functions.

### Conclusion:

These changes enhance the maintainability and functionality of the shopping bag system, improve naming consistency, and integrate new features into the product and bag workflows. The updates also streamline state management and ensure alignment with updated project standards.


## 2024/11/19 - version: 0.7.16+84

This commit introduces enhancements to the star rating display, adds SVG and PNG resources for visual representation, and refines functionality across various components.

### Changes made:

1. **assets/images/star_empty.png, star_full.png, star_half.png**:
   - Added PNG assets for empty, full, and half stars to support the star rating visualization.

2. **assets/svg/Stars.svg**:
   - Added an SVG resource for star shapes, created with Inkscape for vector-based customization and potential export to other formats.

3. **lib/components/collection_views/shop_grid_view/widgets/owner_rating.dart**:
   - Adjusted the `note` variable from `4.5` to `4.2` to demonstrate dynamic star ratings.

4. **lib/components/collection_views/shop_grid_view/widgets/star_rating_bar.dart**:
   - Removed the `material_symbols_icons` dependency for icons.
   - Updated `_createRateRow` to dynamically generate star ratings using PNG assets for empty, half, and full stars.
   - Added logic to handle half-star ratings by rounding the `rate` value appropriately.

5. **lib/components/widgets/favorite_button.dart**:
   - Updated the icon color logic to conditionally assign `null` when the ad is not a favorite, improving UI consistency.

### Conclusion:

This commit enhances the user experience by implementing a dynamic and visually engaging star rating system. The inclusion of SVG and PNG assets ensures flexibility for design adjustments. Additional refinements improve functionality and readability across the codebase.


## 2024/11/20 - version: 0.7.16+83

This commit enhances several components and features across the project, introducing new widgets, refining functionality, and improving overall maintainability and readability.

### Changes made:

1. **lib/components/collection_views/shop_grid_view/widgets/owner_rating.dart**:
   - Added the import for `star_rating_bar.dart`.
   - Replaced the manual star rating display logic with the new `StarRatingBar` widget.
   - Introduced a fixed note value for demonstration purposes.

2. **lib/components/collection_views/shop_grid_view/widgets/star_rating_bar.dart**:
   - Added a new widget `StarRatingBar` to handle dynamic star ratings visually.
   - Implemented a method `_createRateRow` to dynamically create star icons based on the given rating.
   - Designed the widget for reusability across other components.

3. **lib/components/widgets/favorite_button.dart**:
   - Set the icon color to red for the `FavoriteStackButton` to improve visual feedback.

4. **lib/core/models/ad.dart**:
   - Updated the default value for `condition` in `AdModel` from `ProductCondition.all` to `ProductCondition.used`.

5. **lib/features/edit_ad/edit_ad_controller.dart**:
   - Added `_loadBoardgame` method to initialize form fields with ad data.
   - Integrated `_loadBoardgame` into the `init` method to prepopulate the form.

6. **lib/features/edit_ad/edit_ad_form/edit_ad_form.dart**:
   - Adjusted the layout of descriptive text to include ellipsis and max lines for better UX.

7. **lib/features/edit_ad/edit_ad_screen.dart**:
   - Fixed navigation logic by passing the updated ad object when popping the screen.
   - Removed unnecessary debug-related `IconButton`.

8. **lib/features/edit_ad/edit_ad_store.dart**:
   - Added `moveImageLeft` and `moveImageRight` methods to handle reordering of images.
   - Refactored `addImage` and `removeImage` methods to enhance readability and maintainability.

9. **lib/features/edit_ad/image_list/image_list_controller.dart**:
   - Simplified URL validation logic in `removeImage` by replacing regex with `startsWith`.

10. **lib/features/edit_ad/image_list/image_list_view.dart**:
    - Integrated reordering capabilities into the `HorizontalImageGallery` widget.
    - Adjusted layout dimensions for better visual consistency.

11. **lib/features/edit_ad/widgets/horizontal_image_gallery.dart**:
    - Modified the widget to utilize `EditAdStore` for state management.
    - Implemented reordering functionality using the new `moveImageLeft` and `moveImageRight` methods from `EditAdStore`.
    - Enhanced UX by adding icons for reordering and deletion directly on images.

12. **lib/features/shop/shop_screen.dart**:
    - Replaced inline "no ads found" message with the newly created `AdsNotFoundMessage` widget.
    - Removed redundant imports and comments for cleaner code.

13. **lib/features/shop/widgets/ads_not_found_message.dart**:
    - Introduced a new reusable widget `AdsNotFoundMessage` to display a "no ads found" message.
    - Styled the widget for consistency with the app's design system.

### Conclusion:

These updates significantly improve code modularity, readability, and user experience. The addition of reusable components like `StarRatingBar` and `AdsNotFoundMessage` promotes maintainability, while enhancements to image handling and ad editing functionality streamline workflows for both developers and end users.


## 2024/11/19 - version: 0.7.16+82

This commit introduces significant enhancements and new functionality across multiple modules, focusing on boardgame and mechanics management, Parse Server integration, and cloud function improvements.

### Changes made:

1. **`lib/data_managers/boardgames_manager.dart`**:
   - Added `delete` method to handle the deletion of boardgames from both Parse Server and local repository.
   - Improved error handling for boardgame-related operations.

2. **`lib/features/account/boardgames/boardgames_controller.dart`**:
   - Introduced `addBG` and `removeBg` methods to manage boardgame addition and deletion.
   - Enhanced error logging and state handling for boardgame operations.

3. **`lib/features/account/boardgames/boardgames_screen.dart`**:
   - Integrated boardgame deletion confirmation with `SimpleQuestionDialog`.
   - Refactored `editBoardgame` and `addBoardgame` logic for consistency.

4. **`lib/features/account/boardgames/boardgames_store.dart`**:
   - Added `updateBGList` notifier to track boardgame list updates.
   - Implemented `notifiesUpadteBGList` method to handle UI refreshes after operations.

5. **`lib/features/account/boardgames/widgets/dismissible_boardgame.dart`**:
   - Created a new widget to handle swipe actions for editing or deleting boardgames.

6. **`lib/features/account/mechanics/mechanics_controller.dart`**:
   - Renamed `resetMechs` to `removeMechs` for better semantic clarity.
   - Added calls to `notifiesUpdateMechList` after mechanics operations.

7. **`lib/features/account/mechanics/mechanics_store.dart`**:
   - Added `updateMechList` notifier to manage mechanics list updates dynamically.

8. **`lib/features/edit_ad`**:
   - Moved `AdStatus` and `ProductCondition` state management to `EditAdStore`.
   - Updated `edit_ad_controller.dart`, `edit_ad_form.dart`, and `edit_ad_store.dart` for improved separation of concerns.

9. **`lib/repository/data/interfaces/i_boardgame_repository.dart`**:
   - Added `delete` method to the boardgame repository interface.

10. **`lib/repository/data/parse_server`**:
    - **`ps_boardgame_repository.dart`**: Implemented `delete` method for removing boardgames from Parse Server.
    - **`common/ps_functions.dart`**: Added `createSharedAcl` method for public write access to shared items.
    - **`common/constants.dart`**: Fixed typo in `keyAdBoardGame`.

11. **`lib/repository/local_data/sqlite/bg_names_repository.dart`**:
    - Added `delete` method for local boardgame removal.

12. **`lib/store/stores`**:
    - **`bg_names_store.dart`**: Added a `delete` method to support boardgame removal.
    - **`interfaces/i_bg_names_store.dart`**: Updated the interface to include the `delete` method.

13. **`parse_server/cloud/main.js`**:
    - Added multiple cloud functions:
      - `createPaymentPreference`: Generates Mercado Pago payment preferences.
      - `updateStockAndStatus`: Updates stock and marks items as sold when depleted.
      - `afterSave` for `Parse.User`: Automatically assigns new users to the `user` role.
      - `beforeSave` and `beforeDelete` for `Boardgame`: Restricts access to admin users only.
      - `beforeSave` for `AdsSale`: Validates the referenced boardgame during ad creation.

### Conclusion:

These updates enhance the application's robustness by introducing comprehensive boardgame and mechanics management, refining the integration with Parse Server, and adding key cloud function validations. This improves maintainability, security, and user experience.


## 2024/11/18 - version: 0.7.15+81

This commit enhances the mechanics management module, improves functionality across multiple files, refines code consistency, and introduces new capabilities for local database reset and CSV import. Key updates include adding the CSV library, refining methods, and improving state handling.

### Changes made:

1. **`assets/data/bgBazzar.db`**:
   - Updated the binary database file.

2. **`lib/data_managers/boardgames_manager.dart`**:
   - Updated `image.startsWith` logic to check for `keyParseServerImageUrl`.
   - Added a condition to prevent the deletion of remote files by skipping paths starting with `http`.

3. **`lib/data_managers/mechanics_manager.dart`**:
   - Renamed the method `resetDatabase` to `resetLocalDatabase`.
   - Added new methods `getMechanics` and `addLocalDatabase` for handling local database operations.
   - Improved exception handling for database operations.

4. **`lib/features/account/check_mechanics/check_controller.dart`**:
   - Integrated the new `resetLocalDatabase` and `getMechanics` methods.
   - Introduced `loadCSVMechs` to import mechanics from a CSV file.
   - Improved error handling and streamlined the mechanics reset process.

5. **`lib/features/account/check_mechanics/check_page.dart`**:
   - Refactored UI structure for better readability.
   - Improved the mechanics count logic and loading state messages.

6. **`lib/features/account/check_mechanics/check_store.dart`**:
   - Added `counterMax` to enhance state tracking during operations.
   - Updated the `resetCount` method to initialize the counter value.

7. **`lib/features/account/mechanics/mechanics_controller.dart`**:
   - Renamed `deleteMech` to `resetMechs` for better semantic clarity.

8. **`lib/features/account/mechanics/mechanics_screen.dart`**:
   - Updated the call to `resetMechs` to align with the renamed method.

9. **`lib/features/account/mechanics/widgets/mach_floating_action_button.dart`**:
   - Adjusted `heroTag` values for floating action buttons to improve UI state management.

10. **`pubspec.lock` and `pubspec.yaml`**:
    - Added the `csv` library (version 6.0.0) to handle CSV file operations.

### Conclusion:

These updates significantly enhance the mechanics management module by improving local database operations, introducing CSV import capabilities, and refining UI handling. The changes ensure better code readability, state management, and overall maintainability.


## 2024/11/18 - version: 0.7.15+80

This commit introduces comprehensive updates across various modules, focusing on improving functionality, refactoring code, and adding new features related to payment, cart, and user management.

### Changes made:

1. **lib/components/drawers/custom_drawer.dart**:
   - Removed unused `dart:developer` import.
   - Deleted a redundant `log` statement to clean up the logout function.

2. **lib/core/models/ad.dart**:
   - Added `quantity` field to the `AdModel` class.
   - Implemented `toMap`, `fromMap`, `toJson`, and `fromJson` methods for serialization.
   - Removed the `hidePhone` field.

3. **lib/core/models/cart_item.dart**:
   - Created a new `CartItemModel` class for managing items in the cart.
   - Added serialization and deserialization methods.

4. **lib/core/models/payment.dart**:
   - Refactored fields to include `title`, `unitPrice`, and `quantity`.
   - Added serialization and deserialization methods.

5. **lib/core/models/sale.dart**:
   - Created the `SaleModel` class to manage sales, including `SaleStatus` and methods for handling sale items and status updates.

6. **lib/core/models/sale_item.dart**:
   - Created the `SaleItemModel` class to represent items in a sale, including basic fields like `title`, `description`, `quantity`, and `unitPrice`.

7. **lib/core/models/user.dart**:
   - Replaced `UserType` with `UserRole` for better naming clarity.
   - Updated serialization and related logic accordingly.

8. **lib/data_managers**:
   - Added `CartManager` to handle cart-specific operations.
   - Enhanced `MechanicsManager` to support resetting the database.

9. **lib/features**:
   - Introduced `CartController`, `CartStore`, and `CartScreen` for cart management.
   - Refactored `EditAdController` and `EditAdForm` to include quantity handling.
   - Updated the `EditAdStore` to remove `hidePhone` and include `quantity`.
   - Enhanced `CheckMechanicsController` to support resetting mechanics.
   - Added error handling and state management improvements in `PaymentController`.

10. **lib/repository/data**:
    - Refactored interfaces and repositories to use `DataResult` for consistent error handling.
    - Enhanced `PSUserRepository` to include the `removeByEmail` method and `UserRole` handling.

11. **lib/store**:
    - Added `resetDatabase` methods to stores for mechanics and board game names.

12. **parse_server**:
    - Created new Cloud Functions for assigning users to roles and managing stock updates.
    - Added support for `Payment Brick` in the `payment_page.html`.

## Conclusion:

These updates enhance the overall functionality, readability, and scalability of the codebase. The introduction of new models and controllers provides better modularization, while the refactorings improve maintainability and robustness.


## 2024/11/12 - version: 0.7.15+79

This commit enhances the structure and functionality of the ad management features, implementing a more modular and streamlined approach to managing dismissible actions, handling empty states, and renaming the main app entry point.

### Summary of Changes:

1. **Renamed Main App Class**:
   - **lib/my_material_app.dart → lib/app.dart**: Renamed `MyMaterialApp` to `App` for a simpler, more intuitive app entry point.
   - **lib/main.dart**: Updated main entry file to reference `App` instead of `MyMaterialApp`.

2. **Simplified Dismissible Ad Configuration**:
   - **lib/components/collection_views/ad_list_view/ad_list_view.dart**:
     - Removed redundant properties (e.g., color, icon, label for dismissible actions).
     - Simplified `DismissibleAd` instantiation by passing only `adStatus`.

   - **lib/components/collection_views/ad_list_view/widgets/dismissible_ad.dart**:
     - Removed individual configuration parameters for each side and replaced them with `MyAdsDismissible`, which centralizes logic for determining dismissible properties.

3. **Centralized Dismissible Properties Logic**:
   - **lib/features/my_account/my_ads/model/my_ads_dismissible.dart**:
     - Created `MyAdsDismissible` to handle side-specific properties (color, icon, label, status) based on `AdStatus`.
     - Consolidates all dismissible configuration in one place, reducing code duplication and improving readability.

4. **Enhanced Empty State Handling**:
   - **lib/features/my_account/my_ads/my_ads_screen.dart**:
     - Replaced inlined empty state handling with the `NoAdsFoundCard` widget for consistent presentation when no ads are found.

   - **lib/features/my_account/my_ads/widgets/no_ads_found_card.dart**:
     - Added `NoAdsFoundCard` widget to provide a reusable card UI for empty states with a message and icon.

5. **Removed Unused Code and Improved Naming**:
   - **lib/features/my_account/my_ads/my_ads_controller.dart**:
     - Renamed `_adPage` to `_adsDataBasePage` for clarity.
     - Cleaned up redundant code related to pagination.

   - **lib/features/my_account/my_ads/my_ads_store.dart**:
     - Added constants for tab indices and selected tab properties to streamline the tab management in `MyAdsStore`.

6. **Streamlined Tab Bar View Logic**:
   - **lib/features/my_account/my_ads/widgets/my_tab_bar_view.dart**:
     - Refactored the tab bar view to remove hardcoded configurations and integrate the new `MyAdsDismissible`.
     - Updated logic to display `NoAdsFoundCard` when the ads list is empty.

### Conclusion:
This refactor optimizes the ad management feature by reducing redundancy, improving naming conventions, and providing a modular approach to handling dismissible actions. The introduction of `MyAdsDismissible` centralizes logic, making future modifications easier, while the `NoAdsFoundCard` provides a consistent user experience for empty states.


## 2024/11/11 - version: 0.7.13+78

This commit refines the ad editing functionality, improves naming conventions, and introduces enhancements in controller and store management. Key changes include renaming the `EditAdFormController` to `EditAdController`, adding ad saving functionality, and fixing typos in constants.

### Changes made:

1. **lib/features/edit_ad/edit_ad_form/edit_ad_form_controller.dart → lib/features/edit_ad/edit_ad_controller.dart**:
   - Renamed `EditAdFormController` to `EditAdController` to improve naming consistency.
   - Added `saveAd` method to handle the process of saving or updating ads, including error handling and status management.

2. **lib/features/edit_ad/edit_ad_form/edit_ad_form.dart**:
   - Updated imports to use `EditAdController`.
   - Modified `EditAdForm` constructor to accept the new `ctrl` (controller) parameter, ensuring consistency.

3. **lib/features/edit_ad/edit_ad_screen.dart**:
   - Updated the ad save function, `_saveAd`, which now leverages the new `saveAd` method from `EditAdController`.
   - Integrated `EditAdController` into the screen’s lifecycle methods (`initState`, `dispose`) to manage state properly.

4. **lib/features/edit_ad/edit_ad_store.dart**:
   - Renamed `startAd` to `init` for a clearer initialization purpose.
   - Refined `removeImage` method logic to correctly update images and handle validation.

5. **lib/repository/data/parse_server/common/constants.dart**:
   - Corrected typo in `keyAdBoardGame` constant (was `keyAdBoargGame`), aligning the naming with conventional spelling.

6. **lib/repository/data/parse_server/ps_ad_repository.dart**:
   - Updated the `setNonNull` method to use the corrected `keyAdBoardGame` constant.

### Conclusion:
These updates improve the readability and maintainability of the ad editing module. The renaming of classes and methods enhances clarity, while the addition of the `saveAd` method streamlines the ad saving process. Additionally, the correction in constants prevents potential issues with database field names.


## 2024/11/08 - version: 0.7.13+77

This commit introduces several enhancements across the board games and mechanics management features, including functionality improvements, bug fixes, and modularization. Key updates include improving board game selection and editing capabilities, refining controller and store structures, and simplifying component usage in mechanics handling.

### Changes made:

1. **lib/features/my_account/boardgames/boardgames_controller.dart**:
   - Modified `selectBGId` method to be synchronous, enhancing responsiveness in selecting board games.
   - Updated `getBoardgameSelected` to accept an optional `bgId` parameter, improving flexibility when fetching specific board game details.

2. **lib/features/my_account/boardgames/boardgames_screen.dart**:
   - Enhanced `_editBoardgame` method to accept a `BGNameModel` parameter for precise editing of board games.
   - Replaced inline `ListTile` logic with the new `DismissibleBoardgame` widget for better UI handling of board game list items.

3. **lib/features/my_account/boardgames/widgets/custom_floating_action_bar.dart**:
   - Removed the `editBoardgame` button, simplifying the floating action button's functionality.

4. **lib/features/my_account/boardgames/widgets/dismissible_boardgame.dart**:
   - Introduced the `DismissibleBoardgame` widget to handle swipe actions on board games, supporting both edit and delete actions with customizable UI.

5. **lib/features/my_account/boardgames/edit_boardgame/edit_boardgame_controller.dart**:
   - Refactored references from `boardgame` to `bg` to maintain consistency with updated variable names.

6. **lib/features/my_account/boardgames/edit_boardgame/edit_boardgame_form/edit_boardgame_form.dart**:
   - Updated `init` and `setMechanicsPsIds` methods to better integrate mechanics with the board game editing form.

7. **lib/features/my_account/boardgames/edit_boardgame/edit_boardgame_store.dart**:
   - Renamed `boardgame` variable to `bg` for consistency and streamlined its usage across methods.

8. **lib/features/my_account/mechanics/mechanics_controller.dart**:
   - Updated `init` method to remove unnecessary `psIds` parameter, simplifying initialization logic.

9. **lib/features/my_account/mechanics/mechanics_screen.dart**:
   - Adjusted constructor parameter `selectedPsIds` to `selectedMechIds` to better align with naming conventions.
   - Updated initialization to match the modified `MechanicsController` structure.

10. **lib/features/my_account/mechanics/mechanics_store.dart**:
    - Implemented `init` method to initialize selected mechanics from a list of IDs, enhancing the store's setup flexibility.

11. **lib/features/my_account/my_ads/my_ads_controller.dart**:
    - Corrected the `init` method to properly assign the provided `store` to the instance variable, fixing initialization issues.

12. **lib/my_material_app.dart**:
    - Modified route argument for `MechanicsScreen` to use `selectedMechIds`, ensuring parameter consistency throughout the app.

### Conclusion:
This commit significantly enhances both the board games and mechanics features by improving initialization flexibility, standardizing variable names, and introducing modular widgets for list items. These updates contribute to a more maintainable codebase and improved user experience.


## 2024/11/08 - version: 0.7.13+76

This commit introduces several updates to the mechanics feature, including UI enhancements, model functionality improvements, and better modularity in code structure. Notable updates are the addition of the `copyWith` method to `MechanicModel`, the implementation of a new `MechAppBar` and `MechFloatingActionButton`, and updates to `MechanicDialog` for edit functionality.

### Changes made:

1. **lib/core/models/mechanic.dart**:
   - Added a `copyWith` method to allow easy cloning and updating of `MechanicModel` instances.
   - Overridden `==` and `hashCode` for more reliable equality checks, comparing `id`, `name`, and `description` fields.

2. **lib/data_managers/mechanics_manager.dart**:
   - Removed an unnecessary log statement to clean up the code.

3. **lib/features/my_account/mechanics/mechanics_controller.dart**:
   - Added an `update` method to handle updates to `MechanicModel` instances, including setting states for loading, success, and error.

4. **lib/features/my_account/mechanics/mechanics_screen.dart**:
   - Replaced the custom app bar and floating action button with modularized widgets: `MechAppBar` and `MechFloatingActionButton`.
   - Added `_editMechanic` function to allow editing a mechanic by opening `MechanicDialog` with pre-filled data from the selected mechanic.

5. **lib/features/my_account/mechanics/widgets/mach_floating_action_button.dart**:
   - Created `MechFloatingActionButton` to encapsulate floating action button functionalities, including options to add, deselect, and go back. Access is controlled based on user role.

6. **lib/features/my_account/mechanics/widgets/mech_app_bar.dart**:
   - Developed `MechAppBar` to encapsulate app bar functionalities, including title display, search, hide/show description, and filter selected mechanics.

7. **lib/features/my_account/mechanics/widgets/mechanic_dialog.dart**:
   - Updated `MechanicDialog` to support both add and edit functionalities. Now, when editing, it displays the current values and adjusts button text and icons based on the `isEdit` state.
   - Adjusted dialog layout to improve usability, including setting padding and customizing dialog shapes.

8. **lib/features/my_account/mechanics/widgets/show_mechs/show_all_mechs.dart**:
   - Updated `ShowAllMechs` to support the new `editMechanic` callback, allowing items to be edited directly.

### Conclusion:
These updates enhance the user experience and maintainability of the mechanics feature. By modularizing components and adding edit functionality, the UI becomes more intuitive and flexible, and the code becomes easier to manage and extend.


## 2024/11/08 - version: 0.7.13+75

This commit refines and extends various database-related classes and dependency registrations, enhancing modularity, initialization control, and error handling. Notable changes include the introduction of `initialize` methods for deferred asynchronous initialization, interface updates, and error message corrections.

### Changes made:

1. **lib/data_managers/boardgames_manager.dart**:
   - Modified `localBoardgameRepository` to be a late final variable.
   - Added an asynchronous initialization of `localBoardgameRepository` within the `initialize` method.

2. **lib/data_managers/mechanics_manager.dart**:
   - Renamed `_localAdd` to `_addLocalMechanicData` for clarity.
   - Adjusted the error-checking logic to ensure mechanics are only added when the `id` is `null`.

3. **lib/get_it.dart**:
   - Registered `IBgNamesStore` and `IBgNamesRepository` asynchronously with `initialize` methods to ensure deferred loading.

4. **lib/repository/local_data/interfaces/i_bg_names_repository.dart**:
   - Added an `initialize` method to `IBgNamesRepository`, enabling asynchronous setup of repositories.

5. **lib/repository/local_data/sqlite/bg_names_repository.dart**:
   - Introduced `initialize` to set up `bgNamesStore` asynchronously.
   - Updated calls to `bgNamesStore` methods, replacing previous static calls with instance-based calls.

6. **lib/store/stores/bg_names_store.dart**:
   - Implemented `initialize` to prepare the database instance asynchronously.
   - Transitioned static methods (`getAll`, `add`, `update`) to instance methods, aligning with the `IBgNamesStore` interface.

7. **lib/store/stores/interfaces/i_bg_names_store.dart**:
   - Created a new interface `IBgNamesStore`, defining methods `initialize`, `getAll`, `add`, and `update`.

8. **lib/store/stores/mechanics_store.dart**:
   - Corrected error log messages to improve consistency and accuracy.
   - Fixed an issue in the `delete` method, adjusting the `where` clause syntax for SQL query correctness.

### Conclusion:
These changes improve the flexibility and structure of the database management modules by introducing asynchronous initialization, refined method naming, and enhanced error handling. These updates will facilitate smoother integration and setup of repositories while promoting a more modular codebase.


## 2024/11/08 - version: 0.7.13+74

This commit introduces substantial improvements and refactoring to the mechanics-related features, including enhanced modularization, dependency management, and data handling. Additionally, redundant API repositories were removed, and the setup for local repositories and SQLite operations was optimized for better maintainability and performance.

### Changes made:

1. **lib/components/widgets/base_dismissible_container.dart**:
   - Enhanced conditional styling for `Icon` and `Text` color properties within the dismissible container based on the `enable` flag.

2. **lib/data_managers/mechanics_manager.dart**:
   - Refactored `initialize` to load the repository asynchronously.
   - Updated `getAllMechanics` and related methods to use `DataResult` for consistent error handling.
   - Added a `delete` method for mechanics with error handling and logging improvements.

3. **lib/features/my_account/mechanics/**:
   - **check_mechanics** files relocated under a consolidated directory.
   - Updated imports across `check_controller.dart`, `check_page.dart`, and `check_store.dart` to reflect new paths.
   - Adjusted UI components to support updated `MechanicsStore` methods.

4. **lib/features/my_account/mechanics/widgets/show_mechs**:
   - Created `DismissibleMech` widget to encapsulate logic for swipe actions on mechanics with save and delete functions.
   - Split and organized `show_all_mechs.dart` and `show_only_selected_mechs.dart` under `show_mechs`.

5. **lib/get_it.dart**:
   - Modified `ILocalMechanicRepository` registration to use asynchronous initialization for improved dependency management.

6. **lib/repository**:
   - Removed unused `gov_api` repositories (`ibge_repository.dart` and `viacep_repository.dart`), streamlining the codebase and reducing external dependencies.

7. **lib/repository/local_data/interfaces/i_local_mechanic_repository.dart**:
   - Updated method signatures to return `DataResult` for enhanced error handling consistency.
   - Introduced an `initialize` method for repositories requiring setup.

8. **lib/repository/local_data/sqlite/mechanic_repository.dart**:
   - Refactored methods to return `DataResult` for uniform error handling.
   - Integrated `_mechanicsStore` with asynchronous initialization.
   - Implemented comprehensive error logging and custom `DataResult` responses.

9. **lib/store/stores/interfaces/i_mechanics_store.dart**:
   - Defined a new interface `IMechanicsStore` for mechanics-related database operations, providing a consistent contract for SQLite operations.

10. **lib/store/stores/mechanics_store.dart**:
    - Refactored `MechanicsStore` to implement `IMechanicsStore`.
    - Moved SQLite initialization logic to an `initialize` method and removed static references for better dependency management.
    - Enhanced CRUD methods with error handling and reduced code duplication.

11. **lib/my_material_app.dart**:
    - Updated import paths for `check_mechanics/check_page.dart` to reflect the new directory structure.

12. **lib/repository/data/parse_server/ps_mechanics_repository.dart**:
    - Corrected the `delete` method by updating the table name key, ensuring proper data manipulation on the Parse Server.

### Conclusion:
This refactor streamlines data management and dependency injection, ensuring more robust error handling and simplified maintenance. The removal of unused API repositories and restructuring of SQLite interfaces significantly reduces technical debt, while the modularized codebase improves readability and scalability. These changes prepare the project for further enhancements and support a cleaner, more manageable architecture.


## 2024/11/07 - version: 0.7.13+73

This commit enhances the project structure by expanding documentation in the `README.md` file, reorganizing files related to mechanics and payment, and updating the navigation and import paths accordingly. These changes improve clarity and make the codebase easier to navigate, while the new documentation provides a comprehensive overview for future developers.

### Changes made:

1. **README.md**:
   - Expanded project documentation, including an overview, folder structure, and best practices.
   - Added a detailed description of each main directory and its responsibilities, such as `components`, `core`, `data_managers`, `features`, `repository`, `services`, and `store`.
   - Outlined the modular approach to organizing UI components, state management, and business logic, emphasizing code reusability and maintainability.

2. **lib/features/check_mechanics/check_controller.dart**:
   - Moved to `lib/features/my_account/mechanics/check_mechanics/check_controller.dart`.
   - Updated import paths to point to the new structure for `mechanics_manager` and core models.

3. **lib/features/check_mechanics/check_page.dart**:
   - Relocated to `lib/features/my_account/mechanics/check_mechanics/check_page.dart`.
   - Updated import paths for widgets, aligning with the new folder structure.

4. **lib/features/check_mechanics/check_store.dart**:
   - Moved to `lib/features/my_account/mechanics/check_mechanics/check_store.dart`.
   - Adjusted imports to reflect the reorganization, including paths for `mechanic` models and `state_store`.

5. **lib/features/my_account/widgets/admin_hooks.dart**:
   - Updated import paths to accommodate the new location of `check_mechanics/check_page.dart`.

6. **lib/features/payment_web_view/**:
   - Renamed `payment_web_view` to `payment` for simplicity and consistency.
   - Relocated files such as `payment_controller.dart`, `payment_page.dart`, and `payment_store.dart` under `lib/features/payment/`.

7. **lib/my_material_app.dart**:
   - Updated import paths for `payment_page` and `check_mechanics/check_page` to reflect the new directory structure.

### Conclusion:
The expanded README and structural changes improve the documentation and modularity of the codebase. By clearly defining folder responsibilities and enhancing navigation paths, the project is now more maintainable, with a foundation for efficient future development. The refined structure ensures that components, state management, and logic are properly organized, supporting scalability and ease of collaboration.


## 2024/11/07 - version: 0.7.12+72

This commit focuses on reorganizing the project's folder structure, renaming files, and updating import paths to enhance the modularity and maintainability of the codebase. The changes consolidate core components, data managers, and UI features, making the structure more intuitive and easier to navigate.

### Changes made:

1. **lib/features/my_data/my_data_controller.dart**:
   - Moved to `lib/features/my_account/my_data/my_data_controller.dart`.
   - Updated import paths for models, singletons, and utilities, reflecting the new structure in `core`, `data_managers`, and `components`.

2. **lib/features/my_data/my_data_screen.dart**:
   - Relocated to `lib/features/my_account/my_data/my_data_screen.dart`.
   - Adjusted imports to match the updated folder structure and renamed paths.

3. **lib/features/my_account/widgets/admin_hooks.dart**:
   - Updated imports, reflecting renamed paths for `BoardgamesScreen`, `MechanicsScreen`, and product widgets.

4. **lib/features/my_account/widgets/config_hooks.dart**:
   - Renamed and reorganized imports for `AddressesScreen` and `MyDataScreen`, aligning them with the new modular paths.

5. **lib/features/my_account/widgets/sales_hooks.dart**:
   - Adjusted import paths for `MyAdsScreen` and product widgets.

6. **lib/features/my_account/widgets/shopping_hooks.dart**:
   - Modified import paths to integrate updated `shop/product` widgets.

7. **lib/features/payment_web_view/payment_store.dart**:
   - Updated import path for `StateStore` to reflect its new location in `core/state`.

8. **lib/features/product/product_screen.dart**:
   - Moved to `lib/features/shop/product/product_screen.dart` and adjusted imports to reflect the restructured paths.

9. **lib/features/product/widgets/** (multiple files):
   - Files under `widgets` were moved to `lib/features/shop/product/widgets/` and updated to reference models, themes, and components under `core` and `components`.

10. **lib/features/shop/shop_controller.dart**:
    - Updated imports to utilize `core` and `data_managers` for app settings, current user, and repositories.

11. **lib/features/shop/shop_screen.dart**:
    - Updated import paths for core singletons, theme components, and renamed collection views, aligning with the new modular organization.

12. **lib/get_it.dart**:
    - Reorganized dependency injections to align with the new `data_managers` and `repository` paths.
    - Changed `AddressManager` to `AddressesManager` in singleton registration.

13. **lib/main.dart**:
    - Updated import paths for managers and providers, moving shared preferences and services under `app_data` and `parse_server` respectively.

14. **lib/my_material_app.dart**:
    - Updated route names and imports to match the new structure, including paths for screens such as `MyAccountScreen`, `ShopScreen`, and `BoardgamesScreen`.
    - Replaced `NewAddressScreen` with `EditAddressScreen` and `AddressScreen` with `AddressesScreen` for consistency.

15. **lib/repository/parse_server** (multiple files):
    - Moved interfaces and repository files to `lib/repository/data/parse_server`.
    - Updated all imports for models and abstracts to align with `core`, and restructured files to reflect the modular setup.

16. **lib/repository/gov_api/ibge_repository.dart**:
    - Moved to `lib/repository/gov_apis/ibge_repository.dart` and updated imports for models to reference `core`.

17. **lib/repository/gov_api/viacep_repository.dart**:
    - Moved to `lib/repository/gov_apis/viacep_repository.dart` and adjusted imports.

18. **lib/repository/sqlite/** (multiple files):
    - Moved SQLite repositories to `lib/repository/local_data/sqlite`, consolidating all local data repositories under `local_data`.
    - Updated imports to align with `core` and the new paths for interfaces.

19. **lib/services/parse_server_server.dart**:
    - Moved to `lib/services/parse_server/parse_server_server.dart`.

20. **lib/services/payment/payment_service.dart**:
    - Updated imports to align with the `core` structure.

21. **lib/store/database/** (multiple files):
    - Refactored folders within `database` to include `backup`, `migration`, and `providers` subfolders.
    - Updated imports across files to ensure consistency with the `core` and `data_managers` structure.

22. **test/common/abstracts/data_result_test.dart**:
    - Updated import path for `DataResult` to `core`.

23. **test/common/utils/utils_test.dart**:
    - Adjusted import for `Utils` to reflect the new path in `core`.

24. **test/repository/ibge_repository_test.dart**:
    - Modified import path for `ibge_repository.dart` to match the new organization under `gov_apis`.

### Conclusion:
This reorganization enhances the modularity and clarity of the project's folder structure, separating core logic from feature-specific code and improving maintainability. The new structure facilitates future expansion and simplifies the navigation and management of dependencies within the project.


## 2024/11/07 - version: 0.7.12+71

This commit focuses on cleaning up and refining the existing codebase of the bgbazzar application. It includes deletions of unused components, renaming classes for better clarity, and making structural changes to enhance code readability and maintainability.

### Changes made:

1. **Deleted Files**:
   - **lib/common/app_constants.dart**: Removed unused constants, such as `AppPage` and `appTitle`.
   - **lib/components/form_fields/custom_long_form_field.dart**: Deleted the custom form field widget as part of refactoring the form elements.
   - **lib/components/others_widgets/custom_input_formatter.dart**: Removed `CustomInputFormatter` as it was no longer needed in the application.

2. **lib/common/app_info.dart**:
   - Updated `name` from `'xlo_mobx'` to `'BGBazzar'`.
   - Reformatted `privacyPolicyUrl` for better readability.

3. **lib/components/form_fields/custom_mask_field.dart**:
   - Updated import statements to reflect path changes for consistency.

4. **lib/components/others_widgets/fav_button.dart**:
   - **Renamed to `favorite_button.dart`**: The class `FavStackButton` was also renamed to `FavoriteStackButton` to improve readability.

5. **lib/components/others_widgets/fitted_button_segment.dart**:
   - Added detailed documentation to describe the usage and parameters of `FittedButtonSegment`. This aims to improve the understanding of the component for future developers.

6. **lib/components/others_widgets/image_view.dart**:
   - Added detailed documentation to the `ImageView` widget, describing the logic for image loading and the available parameters, improving code clarity.

7. **lib/components/others_widgets/shop_grid_view/widgets/ad_shop_view.dart**:
   - Updated import statement for `favorite_button.dart`.
   - Replaced instances of `FavStackButton` with `FavoriteStackButton`.

8. **lib/features/edit_boardgame/edit_boardgame_form/edit_boardgame_form.dart**:
   - Replaced `CustomLongFormField` with `CustomFormField`, and added a `FIXME` comment noting the replacement for future refactoring.

9. **lib/features/product/product_screen.dart**:
   - Updated the import and usage of `FavStackButton` to `FavoriteStackButton`.

10. **lib/features/shop/shop_controller.dart**:
    - Replaced usage of `appTitle` from `app_constants.dart` with `AppInfo.name` from `app_info.dart` to streamline constant references.

11. **lib/features/shop/shop_store.dart**:
    - Updated the initialization of `pageTitle` to use `AppInfo.name` instead of `appTitle`.

### Conclusion:
This commit removes redundant components, enhances the code's readability by renaming classes, and updates documentation to improve maintainability. The cleanup also ensures that constants and reusable widgets are organized efficiently, contributing to a more consistent and maintainable codebase.


## 2024/11/06 - version: 0.7.12+70

This commit introduces several structural changes to improve modularity, reduce redundancy, and enhance clarity within the bgbazzar codebase. It includes refactoring, renaming, and deletion of obsolete components, along with the migration of repository interfaces to more organized locations.

### Changes made:

1. **lib/common/basic_controller/basic_controller.dart**:
   - Deleted the `BasicController` class as part of streamlining the codebase. This class was no longer necessary after refactoring the controllers.

2. **lib/common/singletons/app_settings.dart**:
   - Removed direct usage of `SharedPreferences` and replaced it with a dependency-injected `IAppPreferencesRepository`.
   - Updated the `_readAppSettings` and `_saveBright` methods to use the new repository for managing preferences.

3. **lib/common/singletons/current_user.dart**:
   - Updated import paths to reflect the new location of `i_user_repository` within the `parse_server` directory.

4. **lib/common/singletons/search_history.dart**:
   - Removed the `SharedPreferences` dependency and integrated `IAppPreferencesRepository`.
   - Changed `init` and `getHistory` to use `prefs` from `IAppPreferencesRepository`.

5. **lib/components/others_widgets/ad_list_view/ad_list_view.dart**:
   - Removed dependency on `BasicController` and replaced it with direct interactions with `ads`, `getMoreAds`, and `updateAdStatus`.

6. **lib/features/address/address_controller.dart**:
   - Updated import paths to use the `parse_server` directory for `i_ad_repository`.

7. **lib/features/address/address_screen.dart**:
   - Updated repository import paths for consistency with new directory structure.

8. **lib/features/favorites/favorite_store.dart**:
   - Renamed and restructured `shared_preferenses.dart` to `favorite_store.dart` and commented out legacy code to prepare for further modularization.

9. **lib/features/favorites/favorites_controller.dart**:
   - Commented out the old implementation of `FavoritesController`, preparing for a new modular approach.

10. **lib/features/my_ads/my_ads_controller.dart**:
    - Removed `BasicController` inheritance and integrated a new store-based approach for state management.
    - Created a dedicated `MyAdsStore` for managing state, enhancing separation of concerns.
    - Refactored various methods to use `store` for handling states such as loading, success, and error.

11. **lib/features/my_ads/my_ads_screen.dart**:
    - Integrated `MyAdsStore` with the UI using `ListenableBuilder` to listen to state changes.
    - Adjusted initialization to work with the newly refactored controller and store.

12. **lib/features/my_ads/widgets/my_tab_bar_view.dart**:
    - Updated `AdListView` instantiation to use the new properties `ads` and `getMoreAds` from the controller.

13. **lib/get_it.dart**:
    - Added registration for `IAppPreferencesRepository` to `GetIt`.
    - Updated various repository paths to align with the new organized structure under `parse_server` and `sqlite`.

14. **lib/main.dart**:
    - Added initialization of `IAppPreferencesRepository`.
    - Changed the order of initialization calls to ensure dependencies are set up correctly.

15. **lib/manager/address_manager.dart**:
    - Updated import paths to reflect changes in repository organization.

16. **lib/manager/boardgames_manager.dart**:
    - Renamed `init` method to `initialize` for clarity.
    - Updated repository import paths.

17. **lib/manager/favorites_manager.dart**:
    - Updated import paths to use repositories from the `parse_server` directory.

18. **lib/manager/mechanics_manager.dart**:
    - Renamed `init` to `initialize` for consistency.
    - Updated import paths for repository interfaces.

19. **lib/repository/share_preferences/app_share_preferences_repository.dart**:
    - Created a new `AppSharePreferencesRepository` class to manage shared preferences using dependency injection. This new approach improves testing capabilities and reduces direct dependency on `SharedPreferences`.

20. **lib/repository/share_preferences/i_app_preferences_repository.dart**:
    - Defined the `IAppPreferencesRepository` interface to abstract preference management operations, making it easier to replace or mock during testing.

21. **Renamed repository interfaces**:
    - Moved repository interfaces from `lib/repository/interfaces` to `lib/repository/parse_server/interfaces`, and updated all references to match this change. This reorganization helps in categorizing the different data sources and their responsibilities.

### Conclusion:
This commit simplifies the code structure by refactoring legacy components, organizing repositories, and separating concerns for better maintainability. The use of dependency injection for shared preferences ensures that future changes in preference management can be handled without impacting multiple parts of the codebase. The improved modularity also facilitates better testing and reduces redundancy.


## 2024/11/05 - version: 0.7.11+69

This commit refactors various parts of the mechanics feature, significantly simplifying the controller logic by utilizing the newly introduced `MechanicsStore` class for state management. In addition, several deprecated files were removed, and redundant methods were replaced to improve maintainability and efficiency.

### Changes made:

1. **assets/old/bgBazzar.db**:
   - Removed the old database file `bgBazzar.db`.

2. **lib/features/mechanics/mechanics_controller.dart**:
   - Replaced `MechanicsState` with `MechanicsStore` for managing mechanics.
   - Removed `ChangeNotifier` and other state-related code, making `MechanicsController` lighter and more focused on business logic.

3. **lib/features/mechanics/mechanics_screen.dart**:
   - Updated to use `MechanicsStore` for state management instead of the previous `MechanicsState` approach.
   - Added `_removeMechanic` method to remove mechanics, which also logs the operation for debugging purposes.

4. **lib/features/mechanics/mechanics_state.dart** (deleted):
   - Removed `MechanicsState` and its various states (`Initial`, `Loading`, `Success`, `Error`).
   - These states are now replaced by the new state management using `MechanicsStore`.

5. **lib/features/mechanics/mechanics_store.dart** (new file):
   - Added `MechanicsStore` to handle the mechanics selection, count, UI flags, and state management.
   - Contains utility methods for selecting/deselecting mechanics, managing UI states, and interacting with `MechanicsController`.

6. **lib/features/mechanics/widgets/search_mechs_delegate.dart**:
   - Updated `SearchMechsDelegate` to use `MechanicsManager` directly for fetching mechanics names, removing the need to pass `mechsNames` as a parameter.

7. **lib/features/mechanics/widgets/show_all_mechs.dart**:
   - Converted `ShowAllMechs` into a stateful widget to work with `MechanicsStore`.
   - Integrated the `MechanicsStore` for managing selections and toggling descriptions.

8. **lib/features/mechanics/widgets/show_only_selected_mechs.dart**:
   - Updated to use `MechanicsStore` for state management and handling the display of selected mechanics.
   - Replaced static parameter passing with dynamic state updates from `MechanicsStore`.

9. **lib/features/my_account/my_account_screen.dart**:
   - Removed duplicate rendering of `AdminHooks`, ensuring only one instance is displayed on the `MyAccountScreen`.

10. **lib/repository/interfaces/i_mechanic_repository.dart**:
    - Added a new `delete(String id)` method to `IMechanicRepository` for deleting mechanics.

11. **lib/repository/parse_server/ps_ad_repository.dart**:
    - Renamed the `delete` method parameter from `ad` to `id` for better clarity.
    - Modified the `_prepareAdForSaveOrUpdate` method to use a simpler conditional structure when setting the `objectId`.

12. **lib/repository/parse_server/ps_boardgame_repository.dart**:
    - Simplified the `_prepareBgForSaveOrUpdate` method by optimizing the way `ParseObject` is initialized.
    - Updated object field setting to use `setNonNull` to ensure non-null values are handled correctly.

13. **lib/repository/parse_server/ps_mechanics_repository.dart**:
    - Added a new `delete(String id)` method to delete a mechanic from the server.
    - Updated `_prepareMechForSaveOrUpdate` to simplify setting the `objectId`.

### Conclusion:
This refactor simplifies the codebase by reducing redundant state management logic and replacing it with a more consistent state management approach using `MechanicsStore`. The overall maintainability and scalability of the mechanics feature are improved, as the store centralizes all state-related functionalities. Additionally, the removal of deprecated files and redundant methods results in a cleaner and more efficient codebase.


## 2024/11/04 - version: 0.7.11+68

This commit includes multiple updates and enhancements across various parts of the codebase, focusing on improving the consistency, maintainability, and reusability of the project components. Key changes include the addition of new methods, the replacement of repetitive code with utility functions, the introduction of a new utility class (`PsFunctions`), and modifications to existing functionalities for better adherence to best practices.

### Changes made:

1. **lib/common/models/bg_name.dart**:
   - Added a `copyWith` method to create copies of `BGNameModel` instances with modified attributes.

2. **lib/components/form_fields/custom_long_form_field.dart**:
   - Added a `FocusNode` as an optional parameter to `CustomLongFormField` for better focus control.

3. **lib/components/others_widgets/state_error_message.dart**:
   - Removed `margin` from the `Container` widget and added it to the `Card` widget for better layout control.

4. **lib/features/edit_boardgame/edit_boardgame_controller.dart**:
   - Removed an unnecessary logging statement from the `EditBoardgameController`.

5. **lib/features/edit_boardgame/edit_boardgame_form/edit_boardgame_form.dart**:
   - Added a `nextFocusNode` parameter to `CustomLongFormField` for smooth focus transitions.
   - Assigned the newly added `FocusNode` to `CustomLongFormField`.

6. **lib/features/edit_boardgame/edit_boardgame_form/edit_boardgame_form_controller.dart**:
   - Added a `FocusNode` (`descriptionFocus`) for managing the focus of the description field.
   - Disposed of `descriptionFocus` in the `dispose` method.

7. **lib/manager/boardgames_manager.dart**:
   - Updated `_getLocalBgNames` to use `getAll` instead of `get` for fetching board game names.
   - Modified `_sortingBGNames` to use a more optimized approach for sorting `_localBGsList`.

8. **lib/repository/parse_server/common/ps_functions.dart** (new file):
   - Introduced `PsFunctions` class with utility methods: `handleError`, `parseCurrentUser`, and `createDefaultAcl`.
   - These utility methods centralize common operations like error handling, fetching the current user, and creating default ACLs, improving reusability.

9. **lib/repository/parse_server/ps_ad_repository.dart**:
   - Replaced repetitive code for fetching the current user, handling errors, and creating ACLs with the utility methods from `PsFunctions`.
   - Removed redundant methods (`_parseCurrentUser`, `_handleError`, `_createDefaultAcl`) that were replaced by the `PsFunctions`.

10. **lib/repository/parse_server/ps_address_repository.dart**:
    - Updated `parseAddress` object setting by replacing standard `set` calls with `setNonNull` to ensure non-nullable fields are consistently handled.

11. **lib/repository/parse_server/ps_boardgame_repository.dart**:
    - Refactored methods to use `PsFunctions` for user retrieval, ACL creation, and error handling.
    - Removed redundant implementations (`_parseCurrentUser`, `_createDefaultAcl`).

12. **lib/repository/parse_server/ps_favorite_repository.dart**:
    - Updated `parseFav` object setting by replacing standard `set` calls with `setNonNull` for consistent handling of non-nullable fields.

13. **lib/repository/parse_server/ps_mechanics_repository.dart**:
    - Used `PsFunctions` for common operations, including user retrieval and ACL creation.
    - Removed redundant code (`_createDefaultAcl`, `_parseCurrentUser`, `_handleError`) that has been centralized in `PsFunctions`.

14. **lib/repository/parse_server/ps_user_repository.dart**:
    - Refactored the error handling to use `PsFunctions.handleError`.
    - Updated user field settings to use `setNonNull` for improved consistency.

15. **lib/repository/sqlite/bg_names_repository.dart**:
    - Renamed method `get` to `getAll` to better reflect its functionality and improve readability.

16. **lib/repository/sqlite/local_interfaces/i_bg_names_repository.dart**:
    - Updated interface method name from `get` to `getAll` to align with the implementation.

17. **lib/store/stores/bg_names_store.dart**:
    - Renamed method `get` to `getAll` for consistency with the repository and interface changes.

### Conclusion:
This commit centralizes common functionalities into reusable components (`PsFunctions`), enhances code clarity, and reduces redundancy. These changes improve the overall maintainability of the codebase, ensuring consistency in error handling, user management, and data access control. Additionally, better focus control in form fields and optimized sorting of board games contribute to a more seamless user experience.


## 2024/11/04 - version: 0.7.11+66

This commit introduces changes aimed at simplifying the data models and repository architecture, eliminating redundant fields and improving the overall consistency of the code. The modifications streamline the handling of IDs across models, ensuring a more uniform approach for data identification and storage.

### Changes made:

1. **assets/data/bgBazzar.db**:
   - Updated the binary data of the SQLite database.

2. **assets/data/bgBazzar2.db**:
   - Removed the deprecated `bgBazzar2.db` database file.

3. **lib/common/models/ad.dart**:
   - Modified `mechanicsString` to use `mec.id` instead of `mec.psId` for consistency with other models.

4. **lib/common/models/bg_name.dart**:
   - Removed the `bgId` field and replaced `id` type from `int` to `String` to align with other models.

5. **lib/common/models/mechanic.dart**:
   - Removed the `psId` field and replaced `id` type from `int` to `String` to standardize data representation.

6. **lib/features/boardgame/boardgame_controller.dart**:
   - Updated `isSelected` and `selectBGId` methods to use `bg.id` instead of `bg.bgId`.

7. **lib/features/boardgame/widgets/search_card.dart**:
   - Modified the `onTap` callback to use `bgBoard.id` instead of `bgBoard.bgId`.

8. **lib/features/check_mechanics/check_controller.dart**:
   - Replaced `mech.psId` with `mech.id` in the `get` method for mechanics.

9. **lib/features/check_mechanics/check_page.dart**:
   - Updated the display of mechanic IDs to use `mech.id` instead of `mech.psId`.

10. **lib/features/mechanics/mechanics_controller.dart**:
    - Updated `isSelectedIndex` and `toogleSelectionIndex` methods to use `mechanics[index].id` instead of `mechanics[index].psId`.

11. **lib/get_it.dart**:
    - Added imports for `i_favorite_repository.dart` and `ps_favorite_repository.dart`.
    - Registered `ILocalMechanicRepository` and `IFavoriteRepository` in `GetIt` for dependency injection.

12. **lib/manager/boardgames_manager.dart**:
    - Updated references to `bgId` to use `id` in methods like `_initializeBGNames` and `_updateLocalDatabaseIfNeeded`.
    - Added a comment for better clarity in the `_sortingBGNames` method.

13. **lib/manager/favorites_manager.dart**:
    - Replaced direct use of `PSFavoriteRepository` with `favoriteRepository` to decouple the implementation.

14. **lib/manager/mechanics_manager.dart**:
    - Removed usage of `psId` in favor of `id` for mechanics throughout the manager.

15. **lib/repository/interfaces/i_favorite_repository.dart** (New file):
    - Created an interface `IFavoriteRepository` to handle adding and deleting favorites.

16. **lib/repository/parse_server/common/parse_to_model.dart**:
    - Updated parsing logic for `BGNameModel` and `MechanicModel` to use `id` instead of `bgId` or `psId`.

17. **lib/repository/parse_server/ps_favorite_repository.dart**:
    - Implemented `IFavoriteRepository` to manage favorite-related operations.

18. **lib/repository/parse_server/ps_mechanics_repository.dart**:
    - Modified `saveMechanic` method to use `mech.id` instead of `mech.psId`.

19. **lib/repository/sqlite/bg_names_repository.dart**:
    - Removed setting `bg.id` after adding a new boardgame to the SQLite database.

20. **lib/repository/sqlite/mechanic_repository.dart**:
    - Removed setting `mech.id` after adding a new mechanic to the SQLite database.

21. **lib/store/constants/constants.dart**:
    - Removed constants `mechPSId` and `bgBgId` as they are no longer required.

22. **lib/store/constants/migration_sql_scripts.dart**:
    - Removed migration scripts related to `mechPSId`.

23. **lib/store/constants/sql_create_table.dart**:
    - Updated `createBgNamesTable` to use `bgId` as a `TEXT PRIMARY KEY` instead of an auto-incrementing integer.

24. **lib/store/stores/mechanics_store.dart**:
    - Removed the `mechPSId` column from the query in the `get` method.

25. **pubspec.yaml**:
    - Updated version from `0.7.10+65` to `0.7.11+66`.

### Conclusion:
These changes simplify the data structure by eliminating redundant ID fields and aligning all models to use a single `id` field of type `String`. This unification improves code maintainability and consistency, while also reducing potential confusion regarding different types of IDs.


## 2024/11/01 - version: 0.7.10+65

This commit introduces significant updates to the dependency injection setup and several repository classes to improve the consistency and scalability of the codebase. Notable changes include the introduction of new interfaces for repositories and the implementation of dependency inversion to ensure better separation of concerns.

### Changes made:

1. **lib/get_it.dart**:
   - Added imports for `i_address_repository.dart` and `ps_address_repository.dart`.
   - Registered `IAddressRepository` with `PSAddressRepository` in `GetIt` for Parse Server dependencies.
   - Introduced `SQFLite Repositories` with the `SqliteBGNamesRepository` registration.

2. **lib/manager/address_manager.dart**:
   - Replaced direct use of `PSAddressRepository` with `IAddressRepository` to decouple the implementation from the `AddressManager`.
   - Utilized `getIt<IAddressRepository>()` to obtain the repository instance for handling CRUD operations.

3. **lib/manager/mechanics_manager.dart**:
   - Added import for `i_local_mechanic_repository.dart`.
   - Introduced `localMechRepository` for handling operations via the local SQLite database.
   - Replaced direct references to `SqliteMechanicRepository` with `localMechRepository` to use dependency injection for better scalability.

4. **lib/repository/interfaces/i_address_repository.dart** (New file):
   - Created an interface `IAddressRepository` defining the contract for saving, deleting, and fetching user addresses.
   - Introduced `AddressRepositoryException` to handle errors related to the address repository.

5. **lib/repository/parse_server/ps_address_repository.dart**:
   - Implemented `IAddressRepository` to provide the address-related functionality specific to Parse Server.
   - Changed methods (`save`, `delete`, `getUserAddresses`) from `static` to instance methods, aligning them with the interface implementation.

6. **lib/repository/sqlite/local_interfaces/i_local_mechanic_repository.dart** (New file):
   - Created an interface `ILocalMechanicRepository` for handling SQLite operations related to game mechanics.
   - Defined methods for retrieving, adding, and updating mechanics within the local database.

7. **lib/repository/sqlite/mechanic_repository.dart**:
   - Updated `SqliteMechanicRepository` to implement `ILocalMechanicRepository`.
   - Converted static methods (`get`, `add`, `update`) to instance methods to comply with the interface requirements.

### Conclusion:
These modifications enhance modularity and flexibility by decoupling specific implementations from the core logic through the use of interfaces. This approach ensures that future changes in the repository implementations are less intrusive, thus promoting easier testing and maintenance.


## 2024/11/01 - version: 0.7.10+64

This commit introduces several key changes to enhance the maintainability of the boardgame application, focusing on improving local storage handling, modularizing state management, and refining UI elements.

#### Changes made:

1. **lib/features/boardgame/boardgame_controller.dart**:
   - Updated the getter for the list of board games (`bgs`) to reference `bgManager.localBGList` instead of `bgManager.bgs`.

2. **lib/features/edit_boardgame/edit_boardgame_controller.dart**:
   - Added logic to check if `boardgame.id` is `null` to decide whether to update an existing board game or save a new one.

3. **lib/features/edit_boardgame/edit_boardgame_form/edit_boardgame_form.dart**:
   - Wrapped the `ImageView` widget in a `ClipRRect` with a border radius of 12 to add rounded corners, enhancing UI consistency.

4. **lib/get_it.dart**:
   - Removed redundant import of `ps_ad_repository.dart`.
   - Added a new import for `bg_names_repository.dart` and registered `IBgNamesRepository` to enhance dependency management.

5. **lib/manager/boardgames_manager.dart**:
   - Refactored the board game manager to use a new local SQLite repository (`IBgNamesRepository`) for managing board game names.
   - Added methods to handle initialization, saving, updating, and local database synchronization.
   - Modularized image processing logic to make board game saving and updating more consistent and maintainable.

6. **lib/repository/parse_server/ps_user_repository.dart**:
   - Introduced `_handleError` method for centralized error logging and handling.

7. **lib/repository/sqlite/bg_names_repository.dart**:
   - Implemented the `IBgNamesRepository` interface, including `get`, `add`, and `update` methods for board game names.

8. **lib/repository/sqlite/local_interfaces/i_bg_names_repository.dart** (new file):
   - Created an interface (`IBgNamesRepository`) to standardize SQLite operations for board game names, ensuring modularity and testability.

#### Conclusion:
These updates improve the consistency of state management, enhance the user experience with improved UI elements, and standardize the handling of local board game names. The refactoring also modularizes the code, making future updates easier to manage and enhancing error handling across the application.


## 2024/11/01 - version: 0.7.10+63

This commit introduces multiple updates to improve code modularity, maintainability, and add new features to the boardgame application. Changes include modifications to build configurations, models, form fields, new feature additions, and the refactoring of various components and screens.

### Changes made:

1. **android/app/build.gradle**:
   - Enabled configurations for code shrinking, obfuscation, and optimization in release builds.
   - Added rules to use `proguard-rules.pro` for ProGuard settings.
   - Added comments to clarify configurations that are not part of the official documentation, to assist with potential troubleshooting in production.

2. **android/app/proguard-rules.pro**:
   - Created a new ProGuard configuration file with a rule to keep the `androidx.lifecycle.DefaultLifecycleObserver` class.

3. **lib/common/models/boardgame.dart**:
   - Removed the `views` property from `BoardgameModel`.
   - Added a factory constructor `BoardgameModel.clean()` to return a default, clean instance of the model.
   - Introduced `copyWith` method to enable easy cloning and modification of `BoardgameModel` instances.

4. **lib/components/form_fields/custom_long_form_field.dart**:
   - Added `onChanged` callback to `CustomLongFormField` for flexibility in form interactions.
   - Updated the `onChanged` function to use the provided `onChanged` callback directly.

5. **lib/components/form_fields/custom_names_form_field.dart**:
   - Added `onChanged` and updated the `onSubmitted` callback to pass the current value.
   - Updated `onChanged` to use the provided callback directly.

6. **lib/components/others_widgets/spin_box_field.dart**:
   - Added `onChange` callback to handle changes in the spin box values.
   - Updated `_increment` and `_decrement` methods to call `_updateOnChange` whenever values are adjusted.

7. **lib/features/boardgame/boardgame_screen.dart**:
   - Replaced the `OverflowBar` for Floating Action Buttons with a new `CustomFloatingActionBar` widget to improve code reuse and consistency.

8. **lib/features/boardgame/widgets/custom_floating_action_bar.dart** (new file):
   - Introduced a new widget `CustomFloatingActionBar` to manage the floating action buttons for boardgame operations.

9. **lib/features/edit_ad/edit_ad_controller.dart.old** (deleted):
   - Removed old and unused file `edit_ad_controller.dart.old` to clean up the project.

10. **lib/features/edit_boardgame/edit_boardgame_controller.dart**:
    - Refactored `EditBoardgameController` to decouple the state management from the controller logic.
    - Integrated `EditBoardgameStore` to handle stateful logic, improving separation of concerns.

11. **lib/features/edit_boardgame/edit_boardgame_form/edit_boardgame_form.dart** (new file):
    - Created a new `EditBoardgameForm` widget to encapsulate the form fields and related logic for editing a boardgame.

12. **lib/features/edit_boardgame/edit_boardgame_form/edit_boardgame_form_controller.dart** (new file):
    - Created a new controller `EditBoardgameFormController` to manage the logic for `EditBoardgameForm`, providing better modularity.

13. **lib/features/edit_boardgame/edit_boardgame_screen.dart**:
    - Updated to use `EditBoardgameForm` and `CustomFilledButton`, enhancing maintainability by breaking down responsibilities.

14. **lib/features/edit_boardgame/edit_boardgame_state.dart** (deleted):
    - Removed the obsolete state management file in favor of using the new `EditBoardgameStore`.

15. **lib/features/edit_boardgame/edit_boardgame_store.dart** (new file):
    - Added `EditBoardgameStore` to handle the boardgame state, including validation and status tracking for editing operations.

16. **lib/features/edit_boardgame/get_image/get_image.dart** (new file):
    - Added a new widget `GetImage` to handle image selection, allowing users to either input a path manually or pick a file using a dialog.
    - Includes functionality for picking local files via the `FilePicker` package.

17. **lib/features/edit_boardgame/widgets/custom_filled_button.dart** (new file):
    - Introduced `CustomFilledButton` widget to provide a consistent styled button for actions throughout the boardgame edit flow.

18. **lib/features/mechanics/mechanics_screen.dart**:
    - Updated the Floating Action Buttons to provide a consistent layout, replacing the `OverflowBar` with individual `Padding` widgets for better spacing control.

19. **lib/get_it.dart**:
    - Registered `IBoardgameRepository` with `PSBoardgameRepository` for dependency injection, enhancing the consistency of repository management.

20. **lib/manager/boardgames_manager.dart**:
    - Updated to use `IBoardgameRepository` instead of directly accessing `PSBoardgameRepository`.
    - Improved dependency injection and separation of concerns.

21. **lib/repository/interfaces/i_ad_repository.dart**:
    - Added detailed comments to document each method, clarifying their purpose and expected behavior for maintainability.

22. **lib/repository/interfaces/i_boardgame_repository.dart** (new file):
    - Created an interface for `IBoardgameRepository` to define the contract for managing boardgame data, promoting modularity and testability.

23. **lib/repository/interfaces/i_mechanic_repository.dart**:
    - Added comprehensive documentation for all methods to improve code clarity and ease of use.

24. **lib/repository/parse_server/common/constants.dart**:
    - Removed `keyBgViews` as it is no longer needed in the updated `BoardgameModel`.

25. **lib/repository/parse_server/common/parse_to_model.dart**:
    - Updated `ParseToModel.boardgameModel()` to remove the mapping for `views` since it is no longer part of the model.

26. **lib/repository/parse_server/ps_ad_repository.dart**:
    - Removed redundant comments and added new error handling to the `delete()` method for better consistency.

27. **lib/repository/parse_server/ps_boardgame_repository.dart**:
    - Implemented `IBoardgameRepository` interface and refactored methods for better consistency and error handling.
    - Added private helper methods to modularize repetitive tasks such as creating ACLs and preparing `ParseObject` instances.

28. **lib/repository/parse_server/ps_mechanics_repository.dart**:
    - Improved code documentation, modularized methods for ACL creation and current user fetching, and enhanced error handling.

29. **pubspec.yaml**:
    - Added `file_picker` dependency (version `8.1.3`) to support local file selection.

30. **pubspec.lock**:
    - Updated to include the `file_picker` package (version `8.1.3`).

### Conclusion:
These changes improve the maintainability and modularity of the boardgame application, making it easier to manage forms, UI components, and state. The addition of new callbacks provides greater flexibility, while the refactoring ensures that state management is more streamlined and separated from UI logic.


## 2024/10/31 - version: 0.7.09+62

This commit refactors and enhances several UI components and navigation flows, with a focus on improving code reuse, consistency, and user interaction. These updates primarily affect form submission behaviors and the handling of navigation within the app.

### Changes made:

1. **lib/components/custom_drawer/custom_drawer.dart**:
   - Added a `setPageTitle` callback parameter to improve flexibility when updating the page title after drawer interaction.
   - Modified `_navAccountScreen` method to use the new `setPageTitle` callback.

2. **lib/components/form_fields/custom_form_field.dart**:
   - Enhanced the `onFieldSubmitted` method to advance focus to the next form field, ensuring a smoother form filling experience.

3. **lib/components/form_fields/password_form_field.dart**:
   - Updated `onFieldSubmitted` to advance focus to the next form field and call `onFieldSubmitted` if it is not null, similar to `custom_form_field.dart`.

4. **lib/features/shop/shop_screen.dart**:
   - Renamed `navToLoginScreen` to `_navToLoginScreen` to reflect private method naming conventions.
   - Updated drawer instantiation to pass the `setPageTitle` function instead of directly using the controller method.
   - Refactored floating action button behavior to use `_navToLoginScreen` method.

5. **lib/features/signin/signin_screen.dart**:
   - Refactored UI to include a new `BigButton` for login action and moved the registration button into a more accessible area.
   - Simplified the form and navigation flow for better usability.

6. **lib/features/signin/widgets/signin_form.dart**:
   - Converted `SignInForm` from a `StatelessWidget` to a `StatefulWidget` to manage `FocusNode` for better form control.
   - Added `nextFocusNode` parameter to the email field to improve user experience.
   - Moved the password field's submission behavior to advance focus and initiate login.

7. **lib/features/signup/signup_screen.dart**:
   - Renamed `signupUser` method to `_signupUser` to follow private method naming conventions.
   - Commented out and removed social media registration buttons (e.g., Facebook) for simplification.

8. **lib/features/signup/widgets/signup_form.dart**:
   - Converted `SignUpForm` from a `StatelessWidget` to a `StatefulWidget` to manage `FocusNode`.
   - Added focus control between password and confirm password fields, allowing for smoother form navigation.
   - Moved the "Sign Up" button to the main `SignUpScreen` for better separation of concerns.

### Conclusion:
The changes introduced in this commit significantly enhance the user experience when interacting with forms by improving focus management and simplifying navigation. Additionally, UI refactorings ensure a consistent look and feel across the application, while adhering to best practices for code organization and reuse.


## 2024/10/30 - version: 0.7.09+61

This commit introduces several important refactorings and improvements across multiple files in the Parse server repositories, focusing on modularizing error handling, refining query logic, and optimizing code readability and maintainability.

### Changes made:

1. **lib/repository/parse_server/common/parse_to_model.dart**:
   - Added `ParseObjectExtensions` extension to allow setting non-null fields on `ParseObject` using the `setNonNull` method.

2. **lib/repository/parse_server/ps_ad_repository.dart**:
   - Updated `moveAdsAddressTo` method to perform multiple ad updates in parallel using `Future.wait`, improving efficiency.
   - Refactored `adsInAddress`, `updateStatus`, `getMyAds`, `get`, `save`, and `update` methods to use a more consistent error handling approach with `_handleError`.
   - Introduced new helper methods `_parseCurrentUser`, `_parseAddress`, `_parseBoardgame`, `_createDefaultAcl`, `_prepareAdForSaveOrUpdate`, and `_handleError` to modularize repetitive logic, improve code readability, and facilitate reuse.
   - Modified `_saveImages` to return directly as a list of `ParseFile` objects instead of wrapping the result in a `DataResult`, and refactored it for clarity and simplicity.
   - Added `_prepareAdForSaveOrUpdate` to centralize ad creation or update logic, using `setNonNull` for all fields to prevent unnecessary null checks.
   - Created new methods to generate `ParseObject` representations of address and board game (`_parseAddress`, `_parseBoardgame`) to improve maintainability.

3. **lib/repository/parse_server/ps_user_repository.dart**:
   - Renamed parameter `message` to `module` in `_handleError` method to standardize error handling parameters and improve log clarity.

### Conclusion:
These changes enhance the modularity and maintainability of the code by encapsulating repeated logic into well-defined helper methods and extensions. Additionally, the adoption of batch updates and parallelism in operations significantly improves performance, while consistent error handling across the repository ensures better error tracking and debugging.


## 2024/10/30 - version: 0.7.09+60

This commit focuses on the restructuring and refactoring of the advertisement and board game models, as well as the migration from `PSAdRepository` to the use of a repository interface (`IAdRepository`). It also includes improvements to state management in the editing advertisements flow, specifically targeting modularity and reusability.

### Changes made:

1. **lib/common/models/ad.dart**:
   - Removed attributes related to board game details (`yearpublished`, `minplayers`, `maxplayers`, `minplaytime`, `maxplaytime`, `age`, `designer`, `artist`), and moved them to the `BoardgameModel` to enhance modularity.
   - Replaced `mechanicsPSIds` with `mechanicsIds` to unify the naming convention.
   - Adjusted constructors, copy methods, and properties to reflect these changes.
   - Updated the `toString` method to reflect the removal of board game details, simplifying the output.

2. **lib/common/models/boardgame.dart**:
   - Renamed the `bgId` attribute to `id` to maintain consistency throughout the codebase.
   - Updated all references to `bgId` in related classes and methods to `id` to ensure consistency.

3. **lib/features/address/address_controller.dart** and **lib/features/address/address_screen.dart**:
   - Replaced `PSAdRepository` with `IAdRepository` via dependency injection (`getIt<IAdRepository>()`), enhancing flexibility and testing capabilities.
   - Updated method calls to use the injected `adRepository` instance instead of directly referencing `PSAdRepository`.

4. **lib/features/edit_ad/**:
   - Removed `edit_ad_controller.dart` and `edit_ad_form/edit_ad_form_store.dart`, consolidating their responsibilities into `edit_ad_store.dart` and `edit_ad_form.dart` to simplify the flow.
   - Updated `edit_ad_form_controller.dart` and `edit_ad_store.dart` to integrate new methods for handling the `BoardgameModel` and ensure smoother state transitions.
   - Added detailed error handling and validation in `EditAdStore` for fields like `images`, `price`, and `address` to improve user input management.
   - Replaced deprecated and redundant attributes (`mechanicsPSIds`, `imagesLength`, etc.) with more dynamic value notifiers, improving state management.
   - Modified the logic for setting board game information in `EditAdStore` to utilize the new `BoardgameModel` reference, centralizing board game details.

5. **lib/features/edit_ad/image_list/**:
   - Refactored `image_list_controller.dart` and deleted `image_list_store.dart`, simplifying image management for advertisements.
   - Introduced new logic in `ImagesListView` to handle dynamic image updates and user feedback, such as minimum image requirements.
   - Updated `HorizontalImageGallery` to remove redundant parameters and make use of the new `EditAdStore` for image handling, streamlining the workflow.

6. **lib/features/edit_boardgame/edit_boardgame_controller.dart**:
   - Updated the attribute `bgId` to `id` for consistency in board game management.
   - Adjusted the logic for saving board game details to reflect the attribute name change, ensuring all related operations are updated.

7. **lib/features/my_ads/my_ads_controller.dart** and **lib/features/shop/shop_controller.dart**:
   - Updated all references from `PSAdRepository` to `IAdRepository` to maintain the new abstraction layer.
   - Leveraged `getIt<IAdRepository>()` for better dependency handling, ensuring all references are updated consistently.
   - Modified methods like `_getAds`, `_getMoreAds`, and `_updateAdStatus` to use the injected repository interface, enhancing code flexibility.

8. **lib/repository/interfaces/i_ad_repository.dart**:
   - Created the `IAdRepository` interface to define methods like `moveAdsAddressTo`, `adsInAddress`, `updateStatus`, `getMyAds`, `get`, `save`, `update`, and `delete`, ensuring consistency in ad data operations.
   - Documented each method to provide clarity on its intended use and expected parameters, facilitating future maintenance and extension.

9. **lib/repository/parse_server/ps_ad_repository.dart**:
   - Implemented `IAdRepository` interface methods in `PSAdRepository` to conform to the newly introduced abstraction.
   - Added the relationship between `AdModel` and `BoardgameModel` to maintain integrity when saving and updating advertisements.
   - Updated methods like `save` and `update` to utilize `ParseObject` relationships for the board game, ensuring proper linkage between ads and their related board games.
   - Removed redundant attributes (`yearpublished`, `minplayers`, etc.) from the Parse save logic, centralizing these details in the `BoardgameModel`.

10. **lib/repository/parse_server/common/constants.dart** and **parse_to_model.dart**:
    - Removed constants related to board game attributes from the `AdModel` and added `keyAdBoargGame` to reflect new data handling.
    - Updated parsing logic to support new relationships between ads and board games, ensuring that board game details are properly retrieved and associated with the advertisement model.
    - Modified the `ParseToModel` utility to handle the nested `BoardgameModel` within `AdModel`, enhancing the separation of concerns and improving data integrity.

### Conclusion:
The refactoring enhances code modularity and maintainability by separating concerns between advertisements and board games. The migration to repository interfaces (`IAdRepository`) paves the way for better testing and future extensibility, while the improvements in state management contribute to a more predictable and user-friendly experience. This detailed restructuring also reduces redundancy, centralizes board game attributes, and enhances overall code readability and scalability.


## 2024/10/30 - version: 0.7.09+59

This commit introduces significant refactoring and structural improvements in the codebase, focusing on the `EditAd` feature. The changes enhance maintainability, readability, and efficiency while optimizing form and controller handling.

### Changes made:

1. **lib/common/models/ad.dart**:
   - Renamed `mechanicsId` to `mechanicsPSIds` for clarity.
   - Added a `get mechanicsString` method for fetching mechanics as a formatted string using `MechanicsManager`.
   - Added a `copyWith` method to simplify the creation of modified copies of `AdModel`.

2. **lib/common/others/validators.dart**:
   - Updated the `name` validation to check if the value length is at least 3 characters.

3. **lib/components/form_fields/custom_form_field.dart**:
   - Added `initialValue` parameter to `CustomFormField`.

4. **lib/features/edit_ad/edit_ad_controller.dart**:
   - Simplified the controller by removing redundant methods and keeping only essential attributes.

5. **lib/features/edit_ad/edit_ad_screen.dart**:
   - Refactored to use the newly structured `EditAdForm`, eliminating the controller dependency and simplifying the form handling.

6. **lib/features/edit_ad/widgets/ad_form.dart**:
   - Renamed to `edit_ad_form.dart`.
   - Reworked form fields to use dedicated controllers (`nameController`, `descriptionController`, etc.).
   - Implemented proper disposal of controllers to prevent memory leaks.

7. **lib/features/edit_ad/widgets/horizontal_image_gallery.dart**:
   - Updated the icon to `Symbols.add_a_photo_rounded` for a more modern UI.

8. **lib/features/edit_boardgame/edit_boardgame_screen.dart**:
   - Updated floating action buttons (`FAB`) to use `OverflowBar` instead of individual FABs for a better user interface.

9. **Refactor Controllers and Stores**:
   - Created separate controllers (`EditAdFormController`, `ImageListController`) and stores (`EditAdFormStore`, `ImageListStore`) for better separation of concerns.
   - Moved image handling logic to `ImageListController` and store state to `ImageListStore`.
   - Introduced `EditAdFormController` and `EditAdFormStore` for managing form data and state within the `EditAd` feature.

10. **lib/repository/parse_server/common/parse_to_model.dart**:
    - Updated references from `mechanicsId` to `mechanicsPSIds` for consistency.

11. **lib/repository/parse_server/ps_ad_repository.dart**:
    - Modified the `save` and `update` methods to use `mechanicsPSIds` instead of `mechanicsId`.

### Conclusion:
This refactoring enhances modularity, making the codebase more organized and maintainable. Controllers and stores have been separated for better control and state management, which also helps in reducing side effects and improving testing capabilities.


## 2024/10/29 - version: 0.7.09+58

This commit refactors the `EditAd` feature, introducing improvements in code structure and component reuse, as well as updating validation logic for better error handling and consistency in form management. Additionally, minor UI improvements have been made to enhance the user experience.

### Changes made:

1. **lib/features/edit_ad/edit_ad_controller.dart**:
   - Removed unnecessary `dispose()` method, as it was empty and redundant.

2. **lib/features/edit_ad/edit_ad_screen.dart**:
   - Updated import from `widgets/ad_form.dart` to `widgets/edit_ad_form.dart`.
   - Removed `dispose()` call on `ctrl` since the controller no longer requires disposal.

3. **lib/features/edit_ad/edit_ad_store.dart**:
   - Updated `_validateDescription()`, `_validateAddress()`, and `_validatePrice()` methods to ensure values are not null before validating their lengths.
   - Added a `resetStore()` method to reset all form validation error messages and image length.

4. **lib/features/edit_ad/widgets/ad_form.dart**:
   - Renamed file to `edit_ad_form.dart` and updated the class to `EditAdForm` for better naming consistency.
   - Added controllers for form fields (`nameController`, `descriptionController`, etc.) to manage state directly within the form.
   - Implemented `dispose()` method to properly dispose of all controllers to prevent memory leaks.
   - Updated form fields to use respective controllers for better control over user input.

5. **lib/features/edit_ad/widgets/horizontal_image_gallery.dart**:
   - Updated the icon in the "add image" button to use `Icons.add_a_photo_rounded` for a more modern appearance.
   - Removed the "+ inserir" text from the button for a cleaner UI.

6. **lib/features/signup/signup_screen.dart**:
   - Simplified the `_navLogin()` method by consolidating the `Navigator.pushNamed()` call into a single line for readability.

### Conclusion:
This commit enhances the maintainability of the `EditAd` feature by restructuring its components for consistency and eliminating redundancy. The improvements in validation logic ensure robust error handling, while the added controllers in `EditAdForm` improve input management. The minor UI adjustments provide a more streamlined user experience.


## 2024/10/29 - version: 0.7.08+57

This commit refactors the code to enhance modularity, consistency, and manageability by introducing a new store class, renaming files, and updating controllers to remove redundancy. The changes focus on improving the architecture, including the management of state and dependency injection across various components.

### Changes made:

1. **lib/common/singletons/current_user.dart**:
   - Updated the import path for `IUserRepository` from `'iuser_repository.dart'` to `'i_user_repository.dart'` for better readability and consistency.

2. **lib/components/others_widgets/shop_grid_view/shop_grid_view.dart**:
   - Replaced the use of `BasicController` with `ShopController` for better specificity in managing shop-related state and logic.

3. **lib/features/favorites/favorites_screen.dart**:
   - Updated the import paths for `ShopController` and `ShopStore`.
   - Replaced `FavoritesController` with `ShopController` and added `ShopStore` to manage state.
   - Updated `AnimatedBuilder` to use `store.state` instead of `ctrl`.

4. **lib/features/my_data/my_data_controller.dart**:
   - Updated the import path for `IUserRepository`.

5. **lib/features/payment_web_view/payment_web_view_page.dart**:
   - Renamed the file to `payment_page.dart`.
   - Renamed `PaymentWebViewPage` class to `PaymentPage` and added a static route name for easier navigation.

6. **lib/features/shop/shop_controller.dart**:
   - Removed inheritance from `BasicController`.
   - Replaced `BasicState` management with `ShopStore` to handle the loading, success, and error states.
   - Consolidated and simplified methods for managing page title and shop data.

7. **lib/features/shop/shop_screen.dart**:
   - Added `ShopStore` to manage the state of `ShopController`.
   - Replaced `AnimatedBuilder` with `ListenableBuilder` to use the store state directly.
   - Updated methods to use `store` for state management and clean disposal.

8. **lib/features/shop/shop_store.dart**:
   - Created a new `ShopStore` class to encapsulate state management for the shop feature.
   - Added methods to handle page title, loading, and success/error state transitions.

9. **lib/features/signin/signin_controller.dart & lib/features/signup/signup_controller.dart**:
   - Updated the import paths for `IUserRepository` for consistency.

10. **lib/get_it.dart**:
    - Removed `ShopController` from dependency registration to align with its updated instantiation in individual screens.
    - Updated repository interface import paths to maintain consistency.
    - Updated repository class names (`PSUserRepository` and `PSMechanicsRepository`) for better readability.

11. **lib/manager/mechanics_manager.dart**:
    - Updated the import path for `IMechanicRepository`.

12. **lib/my_material_app.dart**:
    - Added routing for `PaymentPage` to facilitate navigation by passing a `preferenceId`.

13. **lib/repository/interfaces/imechanic_repository.dart & iuser_repository.dart**:
    - Renamed files to `i_mechanic_repository.dart` and `i_user_repository.dart` for improved consistency in naming conventions.

14. **lib/repository/parse_server/ps_mechanics_repository.dart & ps_user_repository.dart**:
    - Renamed classes to `PSMechanicsRepository` and `PSUserRepository` to maintain consistency with other repository class names.
    - Updated the import paths for the respective interfaces.

### Conclusion:
These changes refactor the codebase to improve maintainability, modularity, and state management. The introduction of `ShopStore` decouples state handling from the controller, allowing for a cleaner separation of concerns. The file renaming and dependency registration changes improve readability and align the project structure with best practices for naming conventions. This refactoring paves the way for easier scalability and enhanced consistency across the codebase.


## 2024/10/29 - version: 0.7.07+56

This commit introduces a new payment integration module using Mercado Pago Bricks and WebView, along with various updates to existing code and new functionalities. The focus of this update is to enhance the payment flow, improve error handling, and add new features for better user experience in managing payments and mechanics checks.

### Changes made:

1. **docs/MP_pagamentos.md**:
   - Added new documentation detailing the integration of Mercado Pago Bricks using Parse Server Cloud Code and WebView in Flutter.
   - Explained the general integration strategy, usage of specific Bricks, and considerations for security and implementation.

2. **lib/common/abstracts/data_result.dart**:
   - Added a new `TimeoutFailure` class to represent a failure due to timeout when making API calls.

3. **lib/common/models/payment.dart**:
   - Introduced a new `PaymentModel` class containing fields for `amount`, `description`, and `quantity` to encapsulate payment information.

4. **lib/features/check_mechanics/check_page.dart**:
   - Updated app bar title from `'Restaurar Mecânicas'` to `'Verificar Mecânicas'`.
   - Added `dispose()` method to properly dispose of `store` when the page is destroyed.

5. **lib/features/check_mechanics/check_store.dart**:
   - Added `count.dispose()` to the `dispose()` method to ensure proper cleanup of resources.

6. **lib/features/my_account/widgets/admin_hooks.dart**:
   - Updated title text from `'Restaurar Mecânicas'` to `'Verificar Mecânicas'`.

7. **lib/features/payment_web_view/payment_controller.dart**:
   - Added a new `PaymentController` class to manage the interaction with WebView for payment processing.
   - Set up navigation delegates to handle page progress, resource errors, and control navigation to ensure a secure and user-friendly payment experience.

8. **lib/features/payment_web_view/payment_store.dart**:
   - Added a new `PaymentStore` class that extends `StateStore` to manage state during payment processing in the `PaymentWebView`.

9. **lib/features/payment_web_view/payment_web_view_page.dart**:
   - Created a new `PaymentWebViewPage` widget to handle displaying the payment process using WebView.
   - Utilized `ValueListenableBuilder` to manage loading, success, and error states during payment.

10. **lib/services/payment/payment_service.dart**:
    - Added a new `PaymentService` class to handle interactions with the Parse Server's Cloud Code for payment preferences.
    - Implemented `getPreferenceId()` method to request a preference ID from the Parse Cloud Function, with proper error handling, including timeout.

11. **pubspec.yaml & pubspec.lock**:
    - Added `webview_flutter` package version `^4.10.0` to integrate WebView for the payment functionality.

### Conclusion:
This commit significantly enhances the payment integration flow by utilizing Mercado Pago Bricks and a WebView approach for a secure and user-friendly experience. The added abstractions for payment models, services, and state management provide a more modular and maintainable structure for handling payments. Furthermore, proper error handling mechanisms were introduced to improve the robustness of the codebase during API interactions.


## 2024/10/28 - version: 0.7.06+55

This commit brings several updates and enhancements to the application, focusing on new features, bug fixes, and improvements to maintainability, UI consistency, and underlying infrastructure changes.

### Changes made:

1. **lib/common/models/user.dart**:
   - Corrected a typo: renamed `createAt` to `createdAt` for consistency.
   - Refactored the `UserModel` class, replacing the `copyFromUserModel` method with `copyWith` to make object modifications more flexible and idiomatic.

2. **lib/components/others_widgets/state_count_loading_message.dart**:
   - Added a new widget called `StateCountLoadingMessage` for displaying loading progress with a counter, improving the user feedback during lengthy operations.

3. **lib/features/address/address_controller.dart**:
   - Updated the `selectAddress` method to toggle selection when the address is already selected.
   - Fixed a typo in method name: corrected `seSelectedAddressName` to `setSelectedAddressName`.

4. **lib/features/address/address_screen.dart**:
   - Replaced some material icons with `MaterialSymbols` for consistency.
   - Refactored `AnimatedBuilder` to `ListenableBuilder` to simplify state listening.
   - Updated the background color of selected address cards for better UI distinction.

5. **lib/features/address/address_store.dart**:
   - Fixed typo in method name: corrected `seSelectedAddressName` to `setSelectedAddressName`.

6. **lib/features/check_mechanics/check_controller.dart**, **lib/features/check_mechanics/check_page.dart**, **lib/features/check_mechanics/check_store.dart**:
   - Added new classes: `CheckController`, `CheckPage`, and `CheckStore` to manage the process of checking and restoring game mechanics data.
   - Implemented methods for comparing local mechanics data against the server, providing error handling and progress tracking.

7. **lib/features/my_account/my_account_screen.dart**:
   - Adjusted the order of widgets: duplicated `AdminHooks` to conditionally render based on user type.
   - Improved widget alignment for better user experience.

8. **lib/features/my_account/widgets/admin_hooks.dart**:
   - Added a new option "Restore Mechanics" for admins, linking to the newly added `CheckPage`.

9. **lib/features/my_account/widgets/config_hooks.dart**:
   - Updated the labels for configuration items to be more concise.

10. **lib/features/product/product_screen.dart**:
    - Updated property references to match the new naming convention (`createdAt`).

11. **lib/features/signin/signin_screen.dart**:
    - Changed `routeName` from `/login` to `/signin` to better reflect the purpose of the page.

12. **lib/get_it.dart**:
    - Registered the `IMechanicRepository` dependency, mapping it to `ParseServerMechanicsRepository`.
    - Enhanced dependency injection setup to align with new architecture changes.

13. **lib/manager/boardgames_manager.dart**:
    - Replaced calls to `BGNamesRepository` with `SqliteBGNamesRepository` to enhance repository naming clarity.

14. **lib/manager/mechanics_manager.dart**:
    - Added support for `IMechanicRepository` using dependency injection via `getIt`.
    - Implemented additional methods for managing mechanics (`update`, `get`) to handle various CRUD operations.

15. **lib/my_material_app.dart**:
    - Added route for `CheckPage`.

16. **lib/repository/interfaces/imechanic_repository.dart**:
    - Created a new interface `IMechanicRepository` defining common methods for mechanic data operations.

17. **lib/repository/parse_server/ps_mechanics_repository.dart**:
    - Implemented `IMechanicRepository`.
    - Added more robust error handling and refactored CRUD methods to align with the repository pattern.

18. **lib/repository/sqlite/bg_names_repository.dart**:
    - Renamed class from `BGNamesRepository` to `SqliteBGNamesRepository` for clarity.

19. **lib/repository/sqlite/mechanic_repository.dart**:
    - Renamed class from `MechanicRepository` to `SqliteMechanicRepository` to differentiate between repositories more clearly.

20. **pubspec.yaml**, **pubspec.lock**:
    - Updated dependencies (`get_it`, `flutter_dotenv`, `flutter_lints`) to the latest versions.
    - Added a new dependency: `material_symbols_icons` for a consistent UI icon set.

### Conclusion:
This commit significantly enhances the application's functionality by adding new features, improving user experience, and refining the internal architecture for better maintainability and extensibility. Additionally, repository patterns and dependency management were refactored to provide a cleaner and more scalable codebase.


## 2024/10/25 - version: 0.7.05+54

This commit adds new functionalities and enhancements to improve user experience, specifically focused on user password recovery and UI improvements for error handling. Additionally, the logic for managing server settings in the main application has been updated.

### Changes made:

1. **lib/components/others_widgets/state_error_message.dart**:
   - Added an optional `icon` parameter to the `StateErrorMessage` widget to allow customized icons for different error messages.
   - Modified the widget layout to make it more flexible, including text alignment and padding adjustments.

2. **lib/features/signin/signin_controller.dart**:
   - Introduced an enum `RecoverStatus` to represent different outcomes of password recovery operations.
   - Added a `recoverPassword` method to handle password reset requests using the `userRepository`.

3. **lib/features/signin/signin_screen.dart**:
   - Updated the `_navLostPassword` method to use the new `recoverPassword` functionality.
   - Added a dialog to provide feedback to the user when a password recovery email is sent.

4. **lib/main.dart**:
   - Changed the `isLocalServer` constant from `true` to `false` to switch the server configuration for production use.

5. **lib/repository/interfaces/iuser_repository.dart**:
   - Added a new method `resetPassword(String email)` to the `IUserRepository` interface for initiating password reset requests.

6. **lib/repository/parse_server/ps_user_repository.dart**:
   - Implemented the `resetPassword` method in `ParseServerUserRepository` to handle password reset requests via Parse Server.
   - Updated error handling in multiple methods to improve log messages for easier debugging.

### Conclusion:
These changes enhance the user experience by adding password recovery functionality and allowing customized error messages. Additionally, the application has been prepared for production use by switching the server setting. Improved error handling provides better support for debugging issues.


## 2024/10/25 - version: 0.7.04+53

This commit introduces significant changes across various parts of the codebase, primarily focusing on refactoring the user management logic, implementing a new repository interface, and improving error handling for user operations. These changes enhance code modularity, testability, and readability by decoupling user-related operations from their Parse Server-specific implementations.

### Changes made:

1. **lib/common/abstracts/data_result.dart**:
   - Updated the `Failure` abstract class to include a new `code` field to represent error codes.
   - Modified `GenericFailure` and `APIFailure` classes to use named parameters for `message` and `code`.

2. **lib/common/parse_server/errors_mensages.dart**:
   - Refactored the `ParserServerErrors` class to use an integer error code instead of parsing a string.
   - Removed the `_getErroCode` function, simplifying error message handling.

3. **lib/common/singletons/current_user.dart**:
   - Added dependency injection for `IUserRepository` to manage user-related actions.
   - Updated `init` and `logout` methods to use `userRepository` instead of `PSUserRepository`.

4. **lib/common/others/enums.dart** renamed to **lib/common/state_store/state_store.dart**:
   - Added a new `StateStore` class to encapsulate the logic for managing state changes with `ValueNotifier`.

5. **lib/features/address/address_controller.dart**:
   - Updated methods to use the `StateStore` class instead of setting `PageState` directly.

6. **lib/features/address/address_store.dart**:
   - Refactored `AddressStore` to extend `StateStore`, inheriting its state management logic.

7. **lib/features/boardgame/boardgame_store.dart**:
   - Refactored `BoardgameStore` to extend `StateStore`, simplifying state management.

8. **lib/features/edit_ad/edit_ad_controller.dart**:
   - Replaced individual controllers (e.g., `nameController`, `descriptionController`) with fields in the `store` object for better encapsulation.

9. **lib/features/edit_ad/edit_ad_screen.dart**:
   - Refactored validation checks to use `store.isValid` instead of form validation logic.
   - Replaced `ListenableBuilder` with `ValueListenableBuilder` for `imagesLength` and validation state.

10. **lib/features/edit_ad/edit_ad_store.dart**:
    - Refactored `EditAdStore` to use new validation and state management fields, including `errorName`, `errorDescription`, etc., to handle error messages.

11. **lib/features/signup/signup_controller.dart** and **lib/features/signup/signup_store.dart**:
    - Integrated `IUserRepository` for signing up users, replacing the direct dependency on `PSUserRepository`.

12. **lib/get_it.dart**:
    - Registered `IUserRepository` as a dependency using `ParseServerUserRepository`.

13. **lib/repository/interfaces/iuser_repository.dart** (new file):
    - Created an interface for user-related operations to abstract the data source, allowing for easier future changes.

14. **lib/repository/parse_server/ps_user_repository.dart**:
    - Implemented `IUserRepository` in `ParseServerUserRepository`.
    - Added detailed error handling with the new `ParserServerErrors` class.
    - Added `_handleError` function to centralize error handling and logging.

### Conclusion:
These changes decouple user management from the specific implementation of Parse Server, making the code more modular and maintainable. The use of `IUserRepository` improves testability and flexibility for future backend changes, while the enhanced state management ensures better user experience and error handling.


## 2024/10/25 - version: 0.7.03+52

**Refactor: Rename Login Feature to SignIn and Implement SignInStore for State Management**

This commit introduces major refactoring by renaming the existing login feature to signin, in order to align naming conventions with other features. The changes include modifications in controllers, screens, widgets, and routes. The state management previously handled by ChangeNotifier has also been migrated to use SignInStore, enhancing separation of concerns and improving maintainability.

### Changes Overview:

1. **Renaming Files and Classes: Login to SignIn**
   - Renamed the login feature directory and relevant files (e.g., `login_controller.dart` to `signin_controller.dart`, `login_screen.dart` to `signin_screen.dart`).
   - Updated class names and imports across the application to reflect the new naming scheme (e.g., `LoginController` to `SignInController`, `LoginScreen` to `SignInScreen`).

2. **Deleted Legacy State Management Classes**
   - Removed `login_state.dart` that contained old state definitions like `LoginStateInitial`, `LoginStateLoading`, etc.
   - Updated state handling from using abstract classes to using the new store-based approach.

3. **Introduction of `SignInStore`**
   - Created a new `signin_store.dart` file for state management.
   - Implemented `SignInStore` using `ValueNotifier` to manage state (`PageState`) and validation errors (e.g., `errorEmail`, `errorPassword`).
   - Integrated `SignInStore` within `SignInController` for streamlined state management.

4. **Simplified Form Widgets**
   - Removed `LoginForm` widget and created `SignInForm` which now uses `SignInStore` for validation and state handling.
   - `SignInForm` is now directly responsible for managing the user input fields (`email` and `password`) through `ValueListenableBuilder` for reactive UI updates.

5. **Route Updates**
   - Replaced all references to `LoginScreen.routeName` with `SignInScreen.routeName` throughout the application.
   - Updated the navigation logic in `shop_screen.dart` and `my_material_app.dart` accordingly.

6. **Miscellaneous Cleanup**
   - Removed redundant focus nodes and controllers from `SignupController`, simplifying the code by directly leveraging the `SignupStore`.
   - Adjusted the signup workflow to ensure a smoother user experience, reflecting the new store-based state management paradigm.

### Conclusion:
This refactoring aligns the feature names, improves readability, and introduces a more scalable state management approach using stores. The change also unifies the naming convention with other parts of the project, thereby improving code consistency and maintainability moving forward.


## 2024/10/24 - version: 0.7.02+51

This commit introduces several changes across multiple files, focusing on improvements in code organization, modularity, and state management. Notable updates include the implementation of a new state management approach with stores replacing old states, and adjustments to enhance the maintainability and consistency of the codebase.

### Changes made:

1. **docker-compose.yml**:
   - Added environment variables to support Parse Server configuration, enabling better parameter control for local and remote setups.

2. **lib/common/validators/validators.dart**:
   - Renamed to `lib/common/others/validators.dart` to better organize utility files.
   - Made `Validator` constructor private to prevent instantiation.

3. **lib/components/form_fields/custom_form_field.dart**:
   - Added `onChanged` and `onFieldSubmitted` callbacks to allow more flexible interactions with the form fields.
   - Updated the implementation to use these new callbacks for cleaner code.

4. **lib/components/form_fields/custom_mask_field.dart** (new file):
   - Introduced a new `CustomMaskField` widget to handle input fields with masked text, supporting better user input control.

5. **lib/components/form_fields/password_form_field.dart**:
   - Updated to use optional controllers and new callbacks (`onChanged`, `onFieldSubmitted`) for more modular code.
   - Replaced `AnimatedBuilder` with `ValueListenableBuilder` for better performance and readability.

6. **lib/features/boardgame/boardgame_controller.dart**:
   - Replaced `BoardgameState` with `BoardgameStore` for state management.
   - Removed the `ChangeNotifier` inheritance to delegate state handling to `BoardgameStore`.

7. **lib/features/boardgame/boardgame_screen.dart**:
   - Updated to use `BoardgameStore` for managing UI state instead of `BoardgameState`.

8. **lib/features/boardgame/boardgame_state.dart** (deleted file):
   - Removed obsolete state class in favor of a new store-based state management approach.

9. **lib/features/boardgame/boardgame_store.dart** (new file):
   - Introduced `BoardgameStore` to replace the previous state-based approach, leveraging `ValueNotifier` for state handling.

10. **lib/features/edit_ad/edit_ad_controller.dart**:
    - Transitioned to use `EditAdStore` for state management, removing the need for `ChangeNotifier`.
    - Removed redundant `ValueNotifier` properties and replaced them with corresponding store methods.

11. **lib/features/edit_ad/edit_ad_state.dart** (deleted file):
    - Deleted the obsolete state file, consolidating all state handling in the new `EditAdStore`.

12. **lib/features/edit_ad/edit_ad_store.dart** (new file):
    - Added `EditAdStore` for better separation of concerns and modular state management.

13. **lib/features/signup/signup_controller.dart**:
    - Updated to use `SignupStore` instead of `SignUpState` for handling UI and data states.

14. **lib/features/signup/signup_state.dart** (deleted file):
    - Removed `SignUpState` in favor of `SignupStore`.

15. **lib/features/signup/signup_store.dart** (new file):
    - Introduced `SignupStore` for more effective state handling in the signup flow, with specific error fields for better user feedback.

16. **lib/get_it.dart**:
    - Added `ParseServerService` to the service locator for better control over Parse Server initialization.

17. **lib/main.dart**:
    - Replaced direct Parse Server initialization with a call to `ParseServerService` for a more modular and testable setup.

18. **lib/services/parse_server_server.dart**:
    - Refactored from `parse_server_location.dart` to include the initialization logic of Parse Server, enhancing modularity.

### Conclusion:
These changes improve the overall modularity and maintainability of the codebase by adopting store-based state management, reducing redundancy, and enhancing the organization of components and services. The new approach simplifies future updates and makes the application more scalable.


## 2024/10/23 - version: 0.7.01+50

This commit updates the Android build configurations, refactors existing classes for better maintainability, and improves code consistency across the application. The changes involve upgrading Gradle versions, refactoring server-related settings, and transitioning the state management approach for the address feature.

### Changes made:

1. **android/app/build.gradle**:
   - Updated `compileSdk`, `minSdk`, and `targetSdk` to version 34 for compatibility with newer Android features.

2. **android/build.gradle**:
   - Added Kotlin version 1.8.10 and updated the build script dependencies.
   - Added buildscript configurations to use Android Gradle plugin version 8.0.2.

3. **android/gradle/wrapper/gradle-wrapper.properties**:
   - Upgraded Gradle distribution to version 8.1.1 for compatibility with the new build script.

4. **lib/common/abstracts/data_result.dart**:
   - Added copyright and licensing information.

5. **lib/features/address/address_state.dart** → **lib/common/others/enums.dart**:
   - Refactored `AddressState` classes into a unified `PageState` enum to simplify state management.

6. **lib/common/settings/back4app_server.dart**:
   - Deleted `back4app_server.dart` as the Back4App configuration has been refactored for better modularity.

7. **lib/common/settings/local_server.dart** → **lib/common/settings/parse_server_location.dart**:
   - Renamed `LocalServer` to `ParseServerLocation` to improve clarity on the server role.

8. **lib/features/address/address_controller.dart**:
   - Replaced the `AddressState` usage with the new `PageState` enum.
   - Removed `ChangeNotifier` inheritance and used `AddressStore` for managing state.

9. **lib/features/address/address_screen.dart**:
   - Modified to use `AddressStore` for state management instead of relying on `ChangeNotifier` directly.

10. **lib/features/address/address_store.dart**:
   - Added new `AddressStore` class to manage the state of address operations, including state tracking and error handling.

11. **lib/features/shop/shop_screen.dart**:
   - Added a spacing line for readability.

12. **lib/main.dart**:
   - Replaced `LocalServer` references with `ParseServerLocation` to reflect the updated server settings class.

13. **lib/manager/boardgames_manager.dart**:
   - Updated the server configuration references from `LocalServer` to `ParseServerLocation` to maintain consistency across the codebase.

14. **pubspec.lock**:
   - Updated the `vm_service` package to version 14.2.5.

### Conclusion:
This refactor improves the overall code organization, especially around server configurations and state management. The upgrade of Android build settings ensures compatibility with newer Android features, while the use of the `AddressStore` enhances state handling in the address feature, contributing to a more maintainable and consistent codebase.


## 2024/08/26 - version: 0.6.19+48

Updated Database and Error Handling Improvements

1. assets/data/bgBazzar.db
   - Updated the binary file `bgBazzar.db` to the latest version.

2. lib/common/singletons/app_settings.dart
   - Updated `_localDBVersion` from `1000` to `1001` to match the new database version.

3. lib/components/others_widgets/bottom_message.dart
   - Created a new widget `BottomMessage` to display messages at the bottom of the screen, compatible with both Android and iOS platforms.

4. lib/features/address/address_controller.dart
   - Modified the `moveAdsAddressTo` method to handle errors using `DataResult`.
   - Added error handling to check for failures and throw appropriate exceptions with detailed error messages.

5. lib/features/address/address_screen.dart
   - Improved error handling in `_removeAddress` method by replacing a placeholder exception with a more descriptive error message.
   - Updated UI elements such as `FloatingActionButton` to improve user experience and make the interface more intuitive.

6. lib/features/boardgame/boardgame_screen.dart
   - Added additional `FloatingActionButton` options for better navigation and action handling within the board game screen.

7. lib/features/boardgame/widgets/bg_info_card.dart
   - Updated the `BGInfoCard` widget to display additional game mechanics using data from `MechanicsManager`.

8. lib/features/edit_ad/edit_ad_controller.dart
   - Enhanced error handling for `update` and `save` methods by implementing `DataResult` to handle potential failures.
   - Updated methods to include descriptive error messages for logging and debugging purposes.

9. lib/features/edit_ad/edit_ad_screen.dart
   - Added a new `IconButton` to the AppBar to allow for printing or debugging ads directly from the UI.
   - Updated UI texts to be more user-friendly.

10. lib/features/edit_ad/widgets/horizontal_image_gallery.dart
    - Added error handling for unsupported platforms when capturing images from the camera.
    - Updated to use the new `BottomMessage` widget to display error messages when necessary.

11. lib/features/mechanics/mechanics_screen.dart
    - Simplified UI by replacing the `PopupMenuButton` with individual `IconButton`s for toggling descriptions and selections.
    - Streamlined user interactions for a cleaner and more intuitive experience.

12. lib/features/my_ads/my_ads_controller.dart
    - Improved error handling in `_getAds` and `_getMoreAds` methods by checking for failures and adding descriptive exceptions.
    - Updated methods to ensure data integrity and better error reporting.

13. lib/features/my_ads/my_ads_screen.dart
    - Updated the icon and text display when no ads are found to improve user feedback.

14. lib/features/product/product_screen.dart
    - Refactored to use a local variable `ad` for easier access and code readability.
    - Integrated a new `GameData` widget to display detailed game information.

15. lib/features/product/widgets/description_product.dart
    - Updated subtitle text to provide a more descriptive label for the product description.

16. lib/features/product/widgets/game_data.dart
    - Added a new widget `GameData` to display detailed information about board games, such as player count, playtime, recommended age, designers, and artists.

17. lib/features/shop/shop_controller.dart
    - Enhanced error handling in `_getAds` and `_getMoreAds` methods by implementing `DataResult` and descriptive error messages.

18. lib/manager/mechanics_manager.dart
    - Added logic to handle missing mechanics by fetching them from the server and adding them to the local repository.
    - Improved logging messages for better traceability.

19. lib/repository/parse_server/ps_ad_repository.dart
    - Fixed the method to return an empty list instead of throwing an exception when no ads are found, improving the flow and error handling.

20. lib/repository/parse_server/ps_mechanics_repository.dart
    - Added a new method `getById` to fetch a mechanic by its ID, improving data retrieval and management capabilities.
    - Improved error handling to provide more specific exceptions and logs.

21. lib/repository/sqlite/mechanic_repository.dart
    - Updated the `add` method to return `null` instead of throwing an exception when adding a mechanic fails, improving error handling and resilience.

22. lib/store/constants/migration_sql_scripts.dart
    - Added a new constant `localDBVersion` set to `1001` to reflect the updated database schema.
    - Added a `FIXME` comment to check database version consistency.

23. pubspec.yaml
    - Updated the project version from `0.6.18+47` to `0.6.19+48` to reflect the new changes and improvements.

These changes aim to enhance the application's error handling, improve user experience, and ensure data consistency and reliability. Feel free to provide additional diffs or specify further adjustments if needed!


## 2024/08/24 - version: 0.6.18+47

In this commit, we introduced several new assets and made significant improvements to error handling and data management across the application. The primary objective was to enhance user experience by providing more robust error handling, consistent image loading, and better structured error messages. The changes include adding new image assets, refactoring image handling logic into a new ImageView widget, and updating various controllers and repositories to utilize the DataResult type for improved error management. These updates are essential for increasing the stability, maintainability, and scalability of the application.

1. assets/images/image_not_found.png
   - Added a new image file to represent missing images.

2. assets/images/image_witout.png
   - Added a new image file to represent images without a specific designation.

3. assets/svg/image_error.svg
   - Added a new SVG file for an error image.
   - Defined SVG properties such as height, width, fill color, and style attributes.

4. assets/svg/image_not_found.svg
   - Added a new SVG file to represent the "image not found" scenario.
   - Defined SVG properties similar to the `image_error.svg`.

5. assets/svg/image_without.svg
   - Added a new SVG file for a generic "image without" representation.
   - Defined SVG properties like height, width, fill color, and style attributes.

6. lib/common/abstracts/data_result.dart
   - Modified the `Failure` class to include an optional `message` parameter.
   - Updated `GenericFailure` and `APIFailure` classes to handle the `message` parameter.

7. lib/components/custon_field_controllers/numeric_edit_controller.dart
   - Added a line to set the text representation of the numeric value in the setter `numericValue`.

8. lib/components/others_widgets/image_view.dart
   - Added a new widget `ImageView` to handle image display with support for assets, network images, and files.

9. lib/features/address/address_screen.dart
   - Updated the `_removeAddress` method to handle error scenarios more gracefully using `DataResult`.

10. lib/features/boardgame/boardgame_controller.dart
    - Refactored `getBoardgameSelected` method to return a `DataResult` type for more structured error handling.

11. lib/features/boardgame/boardgame_screen.dart
    - Updated methods `_editBoardgame` and `_viewBoardgame` to handle failures properly using exceptions.

12. lib/features/boardgame/widgets/bg_info_card.dart
    - Replaced direct image loading with the new `ImageView` widget for consistent error handling.

13. lib/features/edit_ad/edit_ad_controller.dart
    - Refactored the `setBgInfo` method to handle potential failures with structured error messages.

14. lib/features/edit_boardgame/edit_boardgame_controller.dart
    - Updated `getBgInfo` and `saveBoardgame` methods to return `DataResult` types, ensuring better error management.

15. lib/features/edit_boardgame/edit_boardgame_screen.dart
    - Replaced manual image loading logic with the new `ImageView` widget.

16. lib/features/my_ads/my_ads_controller.dart
    - Improved error handling by using `DataResult` types in methods like `_getAds`, `_getMoreAds`, and `updateStatus`.

17. lib/features/shop/shop_controller.dart
    - Enhanced error handling in methods `_getAds` and `_getMoreAds` using the `DataResult` type.

18. lib/manager/boardgames_manager.dart
    - Refactored methods such as `getBGNames`, `save`, and `update` to utilize `DataResult` for more robust error handling.

19. lib/repository/parse_server/ps_ad_repository.dart
    - Updated various methods (`moveAdsAddressTo`, `adsInAddress`, `updateStatus`, etc.) to return `DataResult` types for improved error management.

20. lib/repository/parse_server/ps_boardgame_repository.dart
    - Refactored methods like `save`, `update`, `getById`, and `getNames` to use `DataResult` for better error control.

21. pubspec.yaml
    - Added new asset paths for `assets/images/`.

22. test/common/abstracts/data_result_test.dart
    - Updated unit tests to accommodate changes in `DataResult` handling and ensure tests cover both success and failure scenarios.

23. Improved Error Handling and Messaging
    - Enhanced several methods across different classes to return `DataResult` types instead of raw data or void, allowing for structured error management and more informative error messages. This approach improves the application's stability and makes debugging more straightforward.

24. Refactor of Image Handling
    - Introduced the `ImageView` widget to centralize and standardize image loading across the app. This widget accommodates different image sources (assets, network, and file) and provides a fallback mechanism using placeholder images when the desired image is not found or fails to load.

25. Asset Management
    - Added several new assets, including SVG and PNG images, to handle scenarios where images are not found or an error occurs. This addition aims to enhance the visual feedback for users, ensuring they understand when an image fails to load or is missing.

26. DataResult Implementation
    - Implemented a consistent `DataResult` type across multiple repositories and managers to encapsulate both success and failure states. This implementation allows for more predictable function outputs and enables developers to handle errors uniformly.

27. Test Coverage Updates
    - Modified the unit tests in `data_result_test.dart` to reflect the changes made to the `DataResult` class and its usage across the application. These updates ensure that the test cases validate both the success and failure paths correctly, maintaining high test coverage and reliability.

28. Bug Fixes and Minor Tweaks
    - Fixed minor bugs related to the old image handling logic by replacing it with the new `ImageView` component.
    - Adjusted import paths and removed redundant imports to streamline codebase organization and reduce compile-time dependencies.

These comprehensive updates significantly improve the application's overall stability and user experience by providing better error management and consistent asset handling. The refactoring efforts, particularly around the use of the DataResult type and the introduction of a centralized ImageView widget, ensure more predictable behavior and easier debugging. Moving forward, adopting these patterns across the codebase will help maintain consistency and reduce the likelihood of errors. This commit sets the stage for further enhancements, ensuring a robust foundation for future development.


## 2024/08/22 - version: 0.6.18+46

Update ShoppingHooks with FavoritesScreen integration and minor visual enhancements. Files Modified:

1. `lib/features/my_account/widgets/shopping_hooks.dart`
   - Added: Import statement for `FavoritesScreen`.
   - Modified: Updated `TitleProduct` widget in the ShoppingHooks with the theme's primary color for consistency.
   - Updated: The ListTile for 'Favoritos' now navigates to the `FavoritesScreen` when tapped, using `Navigator.pushNamed`. The color of the icon and text has been set to the primary color for visual coherence.
 
This update introduces navigation to the `FavoritesScreen` from the ShoppingHooks and enhances the visual consistency by applying the primary theme color to specific UI elements. Additionally, the project version has been incremented to ensure proper version control.


## 2024/08/22 - version: 0.6.17+45

Update: Improvements and Refactoring Across Multiple Components. Files and Changes:

1. `lib/common/utils/utils.dart`
   - Added `normalizeFileName` method to standardize filenames by removing accents, replacing spaces with underscores, and removing invalid characters.
   - Introduced `_removeDiacritics` method to handle accent removal for various special characters.

2. `lib/components/others_widgets/spin_box_field.dart`
   - Enhanced initialization logic to ensure the correct value is set in the `NumericEditController` when it's initially zero but should reflect a non-zero value.

3. `lib/features/edit_boardgame/edit_boardgame_screen.dart`
   - Added floating action buttons for saving and canceling operations.
   - Refined UI layout to improve user experience, including the addition of a save and cancel action bar at the bottom.

4. `lib/features/mechanics/mechanics_controller.dart`
   - Refactored to use private fields for better encapsulation.
   - Added `selectMechByName` method for selecting a mechanic by its name.
   - Introduced `toogleDescription` method to show or hide mechanic descriptions.
   - Replaced redundant state management with simplified boolean flags.

5. `lib/features/mechanics/mechanics_screen.dart`
   - Updated the UI to include search functionality with the new `SearchMechsDelegate`.
   - Replaced old mechanics selection logic with a more robust implementation that includes options for showing descriptions and toggling selected items.

6. `lib/features/mechanics/widgets/search_mechs_delegate.dart`
   - Introduced a new widget to provide a search interface for mechanics, allowing for case-sensitive and insensitive searches.

7. `lib/features/mechanics/widgets/show_all_mechs.dart`
   - Updated to handle displaying all mechanics with options to hide descriptions and highlight selected items.

8. `lib/features/mechanics/widgets/show_selected_mechs.dart` -> `lib/features/mechanics/widgets/show_only_selected_mechs.dart`
   - Renamed file and updated logic to better reflect the functionality of displaying only selected mechanics.

9. `lib/manager/boardgames_manager.dart`
   - Added `normalizeFileName` usage when saving board games to ensure filenames are correctly formatted.
   - Introduced `_sortingBGNames` method to keep the list of board games sorted alphabetically by name after any modification.

10. `lib/manager/mechanics_manager.dart`
    - Added `mechanicOfName` method to retrieve mechanics by their name.
    - Updated internal logic to ensure consistency with other components.

11. `lib/repository/parse_server/ps_ad_repository.dart`
    - Updated error logging messages to reflect the correct repository class (`PSAdRepository`) for easier debugging.

12. `lib/repository/parse_server/ps_boardgame_repository.dart`
    - Incorporated `normalizeFileName` into image saving logic to ensure filenames are standardized.
    - Updated error handling to provide clearer exception messages.

This commit introduces various improvements, including new utility methods for filename normalization, enhancements to the mechanics selection process, and improved error handling across multiple repositories. The changes ensure a more consistent and user-friendly experience, with better management of filenames and mechanic data.


## 2024/08/20 - version: 0.6.17+44

Update: Refactor Mechanics IDs and Various Model Updates. Files and Changes:

1. `lib/common/models/ad.dart`
   - Updated `mechanicsId` from `List<int>` to `List<String>` to reflect changes in ID management.

2. `lib/common/models/boardgame.dart`
   - Renamed the `id` field to `bgId`.
   - Updated `mechanics` to `mechsPsIds`, changing the type from `List<int>` to `List<String>`.

3. `lib/common/models/filter.dart`
   - Changed `mechanicsId` to `mechanicsPsId` and updated its type from `List<int>` to `List<String>`.

4. `lib/common/settings/local_server.dart`
   - Added `keyParseServerImageUrl` to manage image URLs more efficiently.

5. `lib/common/singletons/app_settings.dart`
   - Enhanced `_saveBright()` to save brightness settings as 'dark' or 'light' strings.

6. `lib/components/custon_field_controllers/numeric_edit_controller.dart`
   - Improved the `numericValue` setter to better manage old values and trigger appropriate UI updates.

7. `lib/components/others_widgets/spin_box_field.dart`
   - Refactored to use generics, allowing support for both `int` and `double` types in `SpinBoxField`.

8. `lib/features/boardgame/boardgame_screen.dart`
   - Refined the floating action button to allow for multiple actions with tooltips for better UX.

9. `lib/features/edit_ad/edit_ad_controller.dart`
   - Updated `setMechanicsIds()` to `setMechanicsPsIds()` to handle the new `String` ID format.

10. `lib/features/edit_ad/widgets/ad_form.dart`
    - Refactored to use the new `setMechanicsPsIds()` method.

11. `lib/features/edit_boardgame/edit_boardgame_controller.dart`
    - Updated mechanics handling to reflect changes from `int` to `String` for IDs.
    - Introduced a method for updating existing board games.

12. `lib/features/edit_boardgame/edit_boardgame_screen.dart`
    - Modified the initialization to pass `BoardgameModel` objects where applicable.

13. `lib/features/filters/filters_controller.dart`
    - Changed `selectedMechIds` from `List<int>` to `List<String>`.
    - Updated method calls to align with this change.

14. `lib/features/filters/filters_screen.dart`
    - Refined the mechanics selection process to handle `String` IDs.

15. `lib/features/mechanics/mechanics_controller.dart`
    - Adapted the controller to work with `String` IDs.
    - Updated methods for selecting and managing mechanics.

16. `lib/features/mechanics/mechanics_screen.dart`
    - Updated arguments and state management to work with `String` IDs instead of `int`.

17. `lib/features/mechanics/widgets/show_all_mechs.dart`
    - Refined to handle `String` IDs, ensuring compatibility with the rest of the application.

18. `lib/features/my_account/widgets/admin_hooks.dart`
    - Adjusted to pass `String` IDs in the navigation arguments for mechanics management.

19. `lib/manager/boardgames_manager.dart`
    - Implemented `update()` method to handle board game updates with the new `String` ID format.
    - Renamed `saveNewBoardgame()` to `save()` for consistency.

20. `lib/manager/mechanics_manager.dart`
    - Updated to handle `String` IDs for mechanics.
    - Modified the `add()` method to return the new mechanic after saving it to the server.

21. `lib/my_material_app.dart`
    - Adjusted routes to pass `BoardgameModel` objects where required.
    - Updated mechanics selection to handle `String` IDs.

22. `lib/repository/parse_server/common/constants.dart`
    - Removed the now redundant `keyMechId` constant.

23. `lib/repository/parse_server/common/parse_to_model.dart`
    - Updated parsing logic to handle `String` IDs for mechanics and board games.

24. `lib/repository/parse_server/ps_ad_repository.dart`
    - Refined to work with `String` IDs for mechanics within advertisements.

25. `lib/repository/parse_server/ps_boardgame_repository.dart`
    - Implemented an `update()` method for board games, ensuring proper handling of the new `String` IDs.

26. `lib/repository/parse_server/ps_mechanics_repository.dart`
    - Changed method names and return types to work with `String` IDs.
    - Removed the setting of `mechId` in the `add()` method, now relying on `objectId`.

27. `lib/store/constants/migration_sql_scripts.dart`
    - Added a placeholder for a future migration script (version 1002).

28. `lib/store/stores/mechanics_store.dart`
    - Updated queries to include the new `mechPSId` column.

This commit introduces significant changes to the handling of mechanics and board game IDs across the codebase, migrating from `int` to `String` IDs for better compatibility with the Parse server. The update also includes improvements in UI components and overall data management.


## 2024/08/20 - version: 0.6.17+43

Update: Android Manifest, Database Management, and Various Model Enhancements. Files and Changes:

1. `android/app/src/main/AndroidManifest.xml`
   - Added necessary permissions (INTERNET, CAMERA, READ/WRITE_EXTERNAL_STORAGE) as comments for potential future use.
   - Integrated `UCropActivity` for image cropping functionality.

2. `assets/data/bgBazzar.db`
   - Updated database file to include new or modified data.

3. `lib/common/constants/shared_preferenses.dart`
   - Created new constants for managing shared preferences keys (`keySearchHistory`, `keyLocalDBVersion`, `keyBrightness`).

4. `lib/common/models/ad.dart`
   - Reformatted the `toString` method for better readability, adding line breaks between fields.

5. `lib/common/models/mechanic.dart`
   - Added a new `psId` field to the `MechanicModel`.
   - Updated the `toMap`, `fromMap`, and `toString` methods to reflect this change.

6. `lib/common/singletons/app_settings.dart`
   - Implemented methods to manage and persist app settings, including brightness mode and local database version.
   - Enhanced initialization with shared preferences support.

7. `lib/common/singletons/search_history.dart`
   - Updated to use the new shared preferences constants for managing search history.

8. `lib/common/theme/theme.dart`
   - Minor adjustment: changed `scaffoldBackgroundColor` to use `colorScheme.surface` instead of `colorScheme.background`.

9. `lib/components/buttons/big_button.dart`
   - Added support for an optional icon in the `BigButton` widget, allowing more customization.

10. `lib/components/others_widgets/state_error_message.dart`
    - Enhanced the `StateErrorMessage` widget to accept a custom error message.

11. `lib/features/boardgame/boardgame_screen.dart`
    - Fixed an issue where the floating action button was displayed incorrectly based on the user’s admin status.

12. `lib/features/edit_ad/edit_ad_controller.dart`
    - Improved the `setBgInfo` method to handle potential errors when retrieving board game data.
    - Added error handling and updated the UI accordingly.

13. `lib/features/edit_ad/edit_ad_screen.dart`
    - Updated UI labels and buttons to reflect the current context (e.g., "Salvar" vs. "Atualizar").
    - Integrated new icon options for buttons.

14. `lib/features/edit_ad/widgets/ad_form.dart`
    - Refactored the method for retrieving board game information, ensuring proper error handling and feedback.

15. `lib/features/my_account/my_account_screen.dart`
    - Simplified the code by renaming variables for consistency (`currentUser` to `user`).
    - Updated the logout process to use the newly named variable.

16. `lib/get_it.dart`
    - Adjusted imports to reflect the reorganization of the database management files.

17. `lib/main.dart`
    - Added initialization for the database provider to handle migrations and backups.

18. `lib/repository/sqlite/bg_names_repository.dart`
    - Updated the import paths following the reorganization of store files.

19. `lib/repository/sqlite/mechanic_repository.dart`
    - Updated the import paths following the reorganization of store files.

20. `lib/store/constants/constants.dart`
    - Added constants for new database fields (`mechPSId`) and indices.

21. `lib/store/constants/migration_sql_scripts.dart`
    - Added a new script for migrating the database to version 1001, including adding a `psId` field to the `Mechanics` table.

22. `lib/store/database/database_backup.dart`
    - Created a utility class to handle database backups and restoration.

23. `lib/store/database/database_manager.dart`
    - Renamed and refactored to improve database initialization and management processes.

24. `lib/store/database/database_migration.dart`
    - Added a new class to manage database migrations, applying necessary changes to keep the database schema up-to-date.

25. `lib/store/database/database_provider.dart`
    - Created a provider class to handle database initialization, including applying migrations and managing backups.

26. `lib/store/database/database_util.dart`
    - Added utility functions to manage database directories and configurations, abstracting platform-specific logic.

27. `lib/store/bg_names_store.dart` and `lib/store/mechanics_store.dart`
    - Updated paths and imports following the reorganization of the store files.

This commit includes significant updates across various components, focusing on database management, error handling, and UI/UX improvements. It also lays the groundwork for future enhancements by implementing robust database migration and backup strategies.


## 2024/08/15 - version: 0.6.17+42

Refactor: Enhance Theme, Boardgame, Mechanics, and My Account Features. 
Files and Changes:

1. `lib/common/theme/theme.dart`
   - Adjusted color scheme values across different themes to improve visual consistency.
   - Updated the primary, secondary, and tertiary color tones for better contrast and readability.
   - Modified the scaffold background color to match the updated theme configurations.

2. `lib/components/form_fields/custom_form_field.dart`
   - Added `minLines` property support for text fields to allow dynamic height adjustment based on content.

3. `lib/features/boardgame/boardgame_controller.dart`
   - Implemented `getBoardgameSelected` method to retrieve details of the selected board game.
   - Added a method to fetch a board game by its ID and return the corresponding model.

4. `lib/features/boardgame/boardgame_screen.dart`
   - Integrated new actions in the UI to allow adding, editing, and viewing board games directly from the screen.
   - Updated the floating action button behavior to reflect the current user’s role (admin or regular user).

5. `lib/features/boardgame/widgets/bg_info_card.dart`
   - Removed outdated code related to displaying board game views and scoring.

6. `lib/features/boardgame/widgets/view_boardgame.dart`
   - Created a new widget to display detailed information about a board game in a dedicated screen.

7. `lib/features/edit_boardgame/edit_boardgame_screen.dart`
   - Fixed a bug that prevented the screen from closing after saving a board game.
   - Streamlined the on-submit logic for fetching board game information.

8. `lib/features/mechanics/mechanics_controller.dart`
   - Introduced a counter to track and display the number of selected mechanics.
   - Implemented logic to update the counter and reflect the current selection status.

9. `lib/features/mechanics/mechanics_screen.dart`
   - Enhanced the UI to display the number of selected mechanics in the app bar title.
   - Improved the layout and padding for the mechanics list view.

10. `lib/features/mechanics/widgets/mechanic_dialog.dart`
    - Added `minLines` and `maxLines` properties to the description text field for better usability.

11. `lib/manager/boardgames_manager.dart`
    - Added a method to fetch and return a board game by its ID.
    - Streamlined the board game addition process, including saving to the local database and updating the in-memory list.

12. `lib/manager/mechanics_manager.dart`
    - Added methods to sort and update the mechanics list after adding new items to ensure alphabetical order.
    - Separated the logic for adding mechanics to the local and Parse Server databases.

13. `lib/my_material_app.dart`
    - Registered a new route for the `ViewBoardgame` screen.
    - Enhanced the app’s routing logic to handle navigation to the new board game view screen.

14. `lib/features/my_account/my_account_screen.dart`
    - Added a brightness toggle action to the app bar, allowing users to switch between light and dark modes.

This commit introduces various enhancements across the theme settings, board game management, and user interface components. It also includes new functionality for viewing board games and improving the mechanics selection process, ensuring a more seamless and user-friendly experience.


## 2024/08/15 - version: 0.6.17+41

Refactor: Update Boardgame Models and Controller Logic. Files and Changes:

1. `lib/common/models/bg_name.dart`
   - Added the `toString` method to the `BGNameModel` class for easier debugging.
   - Included a new directive to ignore `public_member_api_docs` and `sort_constructors_first` lint warnings.

2. `lib/common/models/boardgame.dart`
   - Removed the `scoring` field from the `BoardgameModel` class as it is no longer required.
   - Updated the `toString` method to reflect the removal of the `scoring` field.

3. `lib/features/boardgame/boardgame_controller.dart`
   - Refactored the controller to manage the search and selection of board games.
   - Removed the `bgName` text controller and replaced the search functionality with a more efficient filtering method.
   - Added methods to manage search filters and handle the selection of board games by their ID.

4. `lib/features/boardgame/boardgame_screen.dart`
   - Updated the UI to use the new filtering mechanism for displaying and selecting board games.
   - Integrated a search dialog to allow users to search for board games by name.
   - Removed the outdated text field and search button for a more streamlined search experience.

5. `lib/repository/parse_server/common/constants.dart`
   - Removed the `keyBgScoring` constant as it is no longer used.

6. `lib/repository/parse_server/common/parse_to_model.dart`
   - Updated the `boardgameModel` method to properly parse the list of mechanics from the Parse Server response.

7. `lib/repository/parse_server/ps_boardgame_repository.dart`
   - Removed the `scoring` field from the methods interacting with the Parse Server.
   - Improved the `getById` method to handle cases where no results are found more gracefully.
   - Corrected error handling and logging in the `getNames` method.

This commit introduces significant improvements to the board game management logic, streamlining the search and selection process. The changes include removing unused fields, enhancing data parsing, and updating the user interface to provide a more efficient and user-friendly experience.


## 2024/08/15 - version: 0.6.16+40

Refactor: Rename and Reorganize Boardgame Search and Management. Files and Changes:

1. `lib/features/bg_search/bg_search_controller.dart` -> `lib/features/boardgame/boardgame_controller.dart`
   - Renamed file and class from `BgController` to `BoardgameController`.
   - Updated the state management references from `BgSearchState` to `BoardgameState`.

2. `lib/features/bg_search/bg_search_screen.dart` -> `lib/features/boardgame/boardgame_screen.dart`
   - Renamed file and class from `BgSearchScreen` to `BoardgameScreen`.
   - Updated route name and widget class names accordingly.

3. `lib/features/boardgames/boardgame_state.dart` -> `lib/features/boardgame/boardgame_state.dart`
   - Renamed file to reflect the updated naming conventions.

4. `lib/features/bg_search/widgets/bg_info_card.dart` -> `lib/features/boardgame/widgets/bg_info_card.dart`
   - Moved the `bg_info_card.dart` widget to the `boardgame` directory.

5. `lib/features/bg_search/widgets/search_card.dart` -> `lib/features/boardgame/widgets/search_card.dart`
   - Moved the `search_card.dart` widget to the `boardgame` directory.

6. `lib/features/edit_ad/widgets/ad_form.dart`
   - Updated imports to reflect the renaming from `BgSearchScreen` to `BoardgameScreen`.

7. `lib/features/boardgames/boardgame_controller.dart` -> `lib/features/edit_boardgame/edit_boardgame_controller.dart`
   - Renamed file and class from `BoardgameController` to `EditBoardgameController`.
   - Updated the state management references from `BoardgameState` to `EditBoardgameState`.

8. `lib/features/boardgames/boardgame_screen.dart` -> `lib/features/edit_boardgame/edit_boardgame_screen.dart`
   - Renamed file and class from `BoardgamesScreen` to `EditBoardgamesScreen`.
   - Updated route name and widget class names accordingly.

9. `lib/features/bg_search/bg_search_state.dart` -> `lib/features/edit_boardgame/edit_boardgame_state.dart`
   - Renamed file and class from `BgSearchState` to `EditBoardgameState`.
   - Updated the state management classes to reflect the new context.

10. `lib/features/my_account/widgets/admin_hooks.dart`
    - Updated import and navigation references from `BgSearchScreen` to `BoardgameScreen`.

11. `lib/my_material_app.dart`
    - Updated route mappings to reflect the renaming from `BgSearchScreen` to `BoardgameScreen` and from `BoardgamesScreen` to `EditBoardgamesScreen`.

This commit refactors and reorganizes the boardgame search and management components, aligning file and class names with their functionalities. The changes enhance code clarity and maintain consistency throughout the project.


## 2024/08/15 - version: 0.6.16+39

Refactor: Rename and Update Boardgame and Mechanics Management. Files and Changes:

1. `lib/common/models/bg_name.dart`
   - Modified `BGNameModel` to use non-final fields.
   - Added `toMap` and `fromMap` methods for easier conversion between `BGNameModel` and `Map<String, dynamic>`.

2. `lib/features/bg_search/bg_search_controller.dart`
   - Renamed the `BgNamesManager` to `BoardgamesManager`.
   - Updated method names to reflect this change.
   - Refactored method `searchBgg` to `searchBg`.

3. `lib/features/bg_search/bg_search_screen.dart`
   - Renamed `BggSearchScreen` to `BgSearchScreen`.
   - Updated the route name and widget class names accordingly.

4. `lib/features/boardgames/boardgame_controller.dart`
   - Renamed `BgNamesManager` to `BoardgamesManager`.
   - Commented out the initialization of BGG rank to focus on the new board game management approach.

5. `lib/features/edit_ad/edit_ad_controller.dart`
   - Removed the unused import of `BgNamesManager`.

6. `lib/features/edit_ad/widgets/ad_form.dart`
   - Updated the route name from `BggSearchScreen.routeName` to `BgSearchScreen.routeName`.

7. `lib/features/my_account/widgets/admin_hooks.dart`
   - Updated the `Boardgames` list tile to navigate to the updated `BgSearchScreen`.

8. `lib/get_it.dart`
   - Replaced `BgNamesManager` with `BoardgamesManager` in the dependency injection setup.

9. `lib/main.dart`
   - Replaced `BgNamesManager` with `BoardgamesManager` during initialization.

10. `lib/manager/bg_names_manager.dart` -> `lib/manager/boardgames_manager.dart`
    - Renamed the file and class from `BgNamesManager` to `BoardgamesManager`.
    - Added logic to manage board games both locally and from the Parse Server.
    - Included methods for fetching and updating board game names.

11. `lib/my_material_app.dart`
    - Updated routes to reflect the renaming from `BggSearchScreen` to `BgSearchScreen`.

12. `lib/repository/sqlite/bg_names_repository.dart`
    - Created a new repository to handle SQLite operations related to board game names.

13. `lib/repository/sqlite/mechanic_repository.dart`
    - Renamed import from `mechanics.dart` to `mechanics_store.dart`.
    - Improved error handling and logging.

14. `lib/store/bg_names.dart` -> `lib/store/bg_names_store.dart`
    - Renamed the file to follow the updated naming conventions.
    - Enhanced methods for adding and updating board game names in the local SQLite database.

15. `lib/store/mechanics.dart` -> `lib/store/mechanics_store.dart`
    - Renamed the file for consistency with the new naming conventions.

This commit refactors the codebase to rename and update the management of board games and mechanics. It introduces a consistent naming convention across files and classes, while also enhancing the integration between local storage and the Parse Server.


## 2024/08/14 - version: 0.6.15+38

Documentation and Code Refactor: Update README and Mechanics Features. Files and Changes:

1. `README.md`
   - Updated the changelog with the latest version `0.6.13+37`, detailing refactoring changes and new features.

2. `lib/common/models/mechanic.dart`
   - Refactored the `MechanicModel` constructor to make the `id` field optional.
   - Simplified the `fromMap` method to remove backward compatibility checks for older field names (`nome` and `descricao`).

3. `lib/features/mechanics/mechanics_controller.dart`
   - Converted `MechanicsController` into a `ChangeNotifier` to manage UI states.
   - Added methods for handling mechanics state (`MechanicsStateLoading`, `MechanicsStateSuccess`, etc.).
   - Improved resource disposal management within the `dispose()` method.

4. `lib/features/mechanics/mechanics_screen.dart`
   - Refactored the mechanics screen to use the new `MechanicDialog` for adding mechanics.
   - Modularized the UI components into separate widgets (`ShowSelectedMechs`, `ShowAllMechs`).
   - Integrated state management for loading and error states.

5. `lib/features/mechanics/mechanics_state.dart`
   - Created a new state management file to handle different states within the mechanics screen (`MechanicsStateInitial`, `MechanicsStateLoading`, etc.).

6. `lib/features/mechanics/widgets/mechanic_dialog.dart`
   - Added a new widget for the mechanics dialog, allowing users to add new mechanics with name and description fields.

7. `lib/features/mechanics/widgets/show_all_mechs.dart`
   - Created a widget to display all mechanics with selection capability.

8. `lib/features/mechanics/widgets/show_selected_mechs.dart`
   - Created a widget to display selected mechanics.

9. `lib/manager/mechanics_manager.dart`
   - Added new methods to fetch mechanics from both local storage and Parse Server.
   - Enhanced mechanics addition logic by integrating local and server-side additions.
   - Implemented `_localAdd` and `_psAdd` methods for better separation of concerns.

10. `lib/repository/parse_server/common/constants.dart`
    - Added constants for mechanics table in the Parse Server (`keyMechTable`, `keyMechObjectId`, `keyMechId`, etc.).

11. `lib/repository/parse_server/common/parse_to_model.dart`
    - Added a new method `mechanic` to parse `ParseObject` into `MechanicModel`.

12. `lib/repository/parse_server/ps_ad_repository.dart`
    - Introduced a private constructor to prevent instantiation of `PSAdRepository`.

13. `lib/repository/parse_server/ps_boardgame_repository.dart`
    - Refined the method to fetch board game names by removing unnecessary null checks.

14. `lib/repository/parse_server/ps_mechanics_repository.dart`
    - Added methods to add and retrieve mechanics from the Parse Server.
    - Implemented error handling and logging for database operations.

15. `lib/repository/sqlite/mechanic_repository.dart`
    - Renamed `getList` to `get` for consistency.
    - Improved error handling and logging within the `get` method.

16. `lib/store/constants/constants.dart`
    - Standardized table names and column names to use consistent casing (`Mechanics`, `mechName`, `mechDescription`).

17. `lib/store/database_manager.dart`
    - Removed obsolete code related to database versioning.
    - Simplified the database initialization logic.

18. `lib/store/mechanics.dart`
    - Renamed `queryMechs` to `get` for better clarity.
    - Improved error logging in the database operations.

19. `pubspec.yaml`
    - Updated the project version to `0.6.15+38` to reflect the latest changes.

This commit includes updates to the documentation, refactors mechanics management, and enhances state management across the mechanics-related features. The codebase is now more modular and maintains better consistency across different components.


## 2024/08/14 - version: 0.6.13+37

Refactor: Update Parse Server Repositories and Add New Features. Files and Changes:

1. `assets/data/bgBazzar.db`
   - Updated the database file.

2. `assets/old/bgBazzar.db`
   - Added an old backup of the `bgBazzar.db` file.

3. `lib/common/singletons/current_user.dart`
   - Replaced `UserRepository` with `PSUserRepository` in methods `init` and `logout`.

4. `lib/features/address/address_controller.dart`
   - Replaced `AdRepository` with `PSAdRepository` in method to move advertisements.

5. `lib/features/address/address_screen.dart`
   - Replaced `AdRepository` with `PSAdRepository`.

6. `lib/features/bg_search/bg_search_controller.dart`
   - Replaced `BoardgameRepository` with `PSBoardgameRepository` in method `getBoardInfo`.

7. `lib/features/boardgames/boardgame_controller.dart`
   - Replaced `BoardgameRepository` with `PSBoardgameRepository` in methods fetching and saving board game data.

8. `lib/features/edit_ad/edit_ad_controller.dart`
   - Replaced `AdRepository` with `PSAdRepository` in methods to save and update advertisements.

9. `lib/features/login/login_controller.dart`
   - Replaced `UserRepository` with `PSUserRepository` in login method.

10. `lib/features/mechanics/mechanics_screen.dart`
    - Added functionality for adding a new mechanic with input fields for name and description.
    - Implemented a floating action button for admin users to add new mechanics.

11. `lib/features/my_account/my_account_screen.dart`
    - Refactored `MyAccountScreen` to use separate widgets for different sections (`AdminHooks`, `ShoppingHooks`, `SalesHooks`, `ConfigHooks`).

12. `lib/features/my_account/widgets/admin_hooks.dart`
    - Created a new widget to handle admin-related actions such as managing mechanics and board games.

13. `lib/features/my_account/widgets/config_hooks.dart`
    - Created a new widget to handle user configuration options such as managing personal data and addresses.

14. `lib/features/my_account/widgets/sales_hooks.dart`
    - Created a new widget to handle sales-related actions such as viewing summaries and managing ads.

15. `lib/features/my_account/widgets/shopping_hooks.dart`
    - Created a new widget to handle shopping-related actions such as managing favorites and purchases.

16. `lib/features/my_ads/my_ads_controller.dart`
    - Replaced `AdRepository` with `PSAdRepository` in methods to fetch and update ads.

17. `lib/features/my_data/my_data_controller.dart`
    - Replaced `UserRepository` with `PSUserRepository` in method to save user data.

18. `lib/features/shop/shop_controller.dart`
    - Replaced `AdRepository` with `PSAdRepository` in methods to fetch ads.

19. `lib/features/signup/signup_controller.dart`
    - Replaced `UserRepository` with `PSUserRepository` in signup method.

20. `lib/manager/address_manager.dart`
    - Replaced `AddressRepository` with `PSAddressRepository` in methods for managing addresses.

21. `lib/manager/bg_names_manager.dart`
    - Replaced `BoardgameRepository` with `PSBoardgameRepository` in methods for managing board game names.

22. `lib/manager/favorites_manager.dart`
    - Replaced `FavoriteRepository` with `PSFavoriteRepository` in methods for managing favorites.

23. `lib/manager/mechanics_manager.dart`
    - Added new methods to add and update mechanics.
    - Implemented `ManagerStatus` enum to manage mechanic status.

24. `lib/repository/parse_server/ad_repository.dart` -> `lib/repository/parse_server/ps_ad_repository.dart`
    - Renamed file and refactored class to `PSAdRepository`.

25. `lib/repository/parse_server/address_repository.dart` -> `lib/repository/parse_server/ps_address_repository.dart`
    - Renamed file and refactored class to `PSAddressRepository`.

26. `lib/repository/parse_server/boardgame_repository.dart` -> `lib/repository/parse_server/ps_boardgame_repository.dart`
    - Renamed file and refactored class to `PSBoardgameRepository`.

27. `lib/repository/parse_server/favorite_repository.dart` -> `lib/repository/parse_server/ps_favorite_repository.dart`
    - Renamed file and refactored class to `PSFavoriteRepository`.

28. `lib/repository/parse_server/user_repository.dart` -> `lib/repository/parse_server/ps_user_repository.dart`
    - Renamed file and refactored class to `PSUserRepository`.

29. `lib/repository/sqlite/mechanic_repository.dart`
    - Added new methods to add and update mechanics in the database.
    - Updated queries to match the new schema.

30. `lib/store/constants/constants.dart`
    - Removed unused columns `mechIndexNome` and `mechDescricao`.
    - Updated constants related to the mechanics table.

31. `lib/store/constants/sql_create_table.dart`
    - Added SQL scripts to create tables for BG names, DB version, and mechanics.

32. `lib/store/database_manager.dart`
    - Updated database manager to handle the creation of new tables and database versions.

33. `lib/store/mechanics.dart`
    - Added new methods to insert, update, and delete mechanics in the SQLite database.

This commit refactors the codebase to adopt a consistent naming convention for Parse Server repositories, introduces new widgets for modularization in the `MyAccountScreen`, and enhances mechanics management features. The database schema and initialization logic have also been updated to support new features.


## 2024/08/13 - version: 0.6.13+36

Update database file name and refactor project components for better organization and functionality.


1. assets/data/bgg.db
   - Renamed to `assets/data/bgBazzar.db`.
   - Binary content of the file has changed.

2. lib/common/models/bg_name.dart
   - Updated `BGNameModel`:
     - Changed `id` type from `String?` to `int?`.
     - Added `bgId` field of type `String?`.

3. lib/common/models/boardgame.dart
   - Updated `BoardgameModel`:
     - Replaced `weight` field with `views` of type `int` and set default value to `0`.
     - Adjusted `toString` method to reflect these changes.

4. lib/common/singletons/current_user.dart
   - Added `isAdmin` getter to return whether the current user is an admin.

5. lib/components/custon_field_controllers/numeric_edit_controller.dart
   - Modified `NumericEditController`:
     - Made it generic to support both `int` and `double` types.
     - Improved validation and handling of numeric input based on the type.
     - Refactored `_validateNumber` method for better clarity.

6. lib/components/form_fields/custom_form_field.dart
   - Added `labelStyle` parameter for customizing the text style of the label.

7. lib/components/form_fields/custom_long_form_field.dart
   - Introduced a new `CustomLongFormField` widget to handle multi-line text input with various customization options.

8. lib/components/form_fields/custom_names_form_field.dart
   - Added `labelStyle` parameter for text style customization of the label.

9. lib/components/others_widgets/spin_box_field.dart
   - Refactored the widget:
     - Removed redundant `SizedBox` wrappers.
     - Replaced `TextField` with `ListenableBuilder` to dynamically display numeric values.

10. lib/features/bg_search/bg_search_controller.dart
    - Updated to include `CurrentUser` for checking admin rights.
    - Adjusted methods to match updated data models.

11. lib/features/bg_search/bg_search_screen.dart
    - Updated UI to support admin functionality:
      - Added FAB to add a new board game if the user is an admin.
      - Refactored padding and UI components for better spacing.

12. lib/features/bg_search/widgets/bg_info_card.dart
    - Commented out the display of `views` and `scoring` for further adjustments.

13. lib/features/bg_search/widgets/search_card.dart
    - Replaced `getBoardInfo` parameter from `id` to `bgId` to reflect updated data model.

14. lib/features/boardgames/boardgame_controller.dart
    - Refactored to use updated `NumericEditController` for various integer-based inputs.
    - Added methods to save board games and handle mechanics more effectively.

15. lib/features/boardgames/boardgame_screen.dart
    - Updated UI components:
      - Added fields for image upload and mechanic selection.
      - Implemented save functionality with data validation.

16. lib/manager/bg_names_manager.dart
    - Refactored to handle image conversion and saving of new board games.
    - Adjusted methods to support new data model changes.

17. lib/repository/parse_server/boardgame_repository.dart
    - Replaced `weight` field with `views` in Parse Server operations.

18. lib/repository/parse_server/common/constants.dart
    - Updated database constants to reflect the change from `weight` to `views`.

19. lib/repository/parse_server/common/parse_to_model.dart
    - Adjusted model parsing to reflect changes in the data model.

20. lib/repository/sqlite/mechanic_repository.dart
    - Updated to use `MechanicsStore` for querying mechanics.

21. lib/store/mech_store.dart
    - Renamed to `bg_names.dart` and refactored to better align with its purpose.

22. lib/store/constants/constants.dart
    - Updated database configuration:
      - Renamed `dbName` to `bgBazzar.db`.
      - Updated constants related to database structure and schema.

23. lib/store/database_manager.dart
    - Enhanced initialization process to support different platforms and configurations.
    - Included the setup for a new directory structure on desktop platforms.

24. lib/store/mechanics.dart
    - Added new store class `MechanicsStore` to handle mechanic-related database operations.

25. pubspec.yaml & pubspec.lock
    - Added dependencies:
      - `sqflite_common_ffi`
      - `sqflite_common_ffi_web`
      - `image`
    - Updated assets path to reflect the renamed database file.

26. web/index.html
    - Included cropper.js library for handling image cropping functionality.

This commit reorganizes and enhances the project by renaming and refactoring several components. It includes updates to the database file and structure, introduces new dependencies, and enhances user interface elements to better support functionality, particularly for board game management and image handling.


## 2024/08/12 - version: 0.6.12+35

Refactor project structure by organizing repositories into more descriptive directories

1. lib/repository/bgg_rank_repository.dart
   - Renamed and moved to `lib/repository/bgg_xml/bgg_rank_repository.dart` to better reflect its association with BGG XML API.

2. lib/repository/bgg_xmlapi_repository.dart
   - Renamed and moved to `lib/repository/bgg_xml/bgg_xmlapi_repository.dart` to align with other BGG-related repositories.

3. lib/repository/ibge_repository.dart
   - Renamed and moved to `lib/repository/gov_api/ibge_repository.dart` to categorize it under government APIs.

4. lib/repository/viacep_repository.dart
   - Renamed and moved to `lib/repository/gov_api/viacep_repository.dart` to keep it alongside other government-related APIs.

5. lib/repository/ad_repository.dart
   - Renamed and moved to `lib/repository/parse_server/ad_repository.dart` to clearly indicate its reliance on Parse Server.

6. lib/repository/address_repository.dart
   - Renamed and moved to `lib/repository/parse_server/address_repository.dart` for better organization under Parse Server.

7. lib/repository/boardgame_repository.dart
   - Renamed and moved to `lib/repository/parse_server/boardgame_repository.dart` to group all Parse Server-related repositories together.

8. lib/repository/common/constants.dart
   - Renamed and moved to `lib/repository/parse_server/common/constants.dart` to keep constants within the Parse Server directory.

9. lib/repository/common/parse_to_model.dart
   - Renamed and moved to `lib/repository/parse_server/common/parse_to_model.dart` to keep model parsing logic within Parse Server.

10. lib/repository/favorite_repository.dart
    - Renamed and moved to `lib/repository/parse_server/favorite_repository.dart` to be consistent with other Parse Server repositories.

11. lib/repository/user_repository.dart
    - Renamed and moved to `lib/repository/parse_server/user_repository.dart` to maintain consistency in the Parse Server directory.

12. lib/repository/mechanic_repository.dart
    - Renamed and moved to `lib/repository/sqlite/mechanic_repository.dart` to clarify its use of SQLite.

13. lib/store/bgg_rank_store.dart
    - Renamed and moved to `lib/repository/sqlite/store/bgg_rank_store.dart` to better categorize store-related files under SQLite.

14. lib/store/constants/constants.dart
    - Renamed and moved to `lib/repository/sqlite/store/constants/constants.dart` to align with SQLite-related stores.

15. lib/store/database_manager.dart
    - Renamed and moved to `lib/repository/sqlite/store/database_manager.dart` to centralize database management under SQLite.

16. lib/store/mech_store.dart
    - Renamed and moved to `lib/repository/sqlite/store/mech_store.dart` to group all mechanic-related stores within SQLite.

This commit reorganizes the project structure by categorizing repositories and stores into more descriptive directories, improving the clarity and maintainability of the codebase.


## 2024/08/12 - version: 0.6.11+34

Refactor project to rename from `xlo_parse_server` to `bgbazzar` and update related files

1. README.md
   - Renamed project title from `xlo_parse_server` to `bgbazzar`.
   - Updated references in the TODO list and project description.

2. android/app/build.gradle
   - Changed `namespace` from `br.dev.rralves.xlo_parse_server` to `br.dev.rralves.bgbazzar`.
   - Updated `applicationId` to `br.dev.rralves.bgbazzar`.

3. android/app/src/main/AndroidManifest.xml
   - Updated `package` attribute to `br.dev.rralves.bgbazzar`.
   - Changed `android:label` to `bgbazzar`.

4. android/app/src/main/kotlin/br/dev/rralves/bgbazzar/MainActivity.kt
   - Renamed package from `br.dev.rralves.xlo_parse_server` to `br.dev.rralves.bgbazzar`.

5. ios/Runner.xcodeproj/project.pbxproj
   - Updated `PRODUCT_BUNDLE_IDENTIFIER` references from `com.example.xloParseServer` to `br.dev.rralves.xloParseServer`.

6. ios/Runner/AppDelegate.swift
   - Changed the annotation from `@UIApplicationMain` to `@main`.

7. lib/common/abstracts/data_result.dart
   - Added a new abstract class `DataResult` for handling either success or failure outcomes, inspired by Swift and Dart implementations.
   - Introduced `Failure`, `GenericFailure`, `APIFailure`, `_SuccessResult`, and `_FailureResult` classes.

8. lib/common/models/ad.dart
   - Removed `bggId` property from `AdModel`.
   - Reorganized `toString` method to include new properties like `yearpublished`, `minplayers`, `maxplayers`, `minplaytime`, `maxplaytime`, `age`, `designer`, and `artist`.

9. lib/common/models/boardgame.dart
   - Refactored properties: replaced `id`, `name`, `yearpublished`, `minplayers`, `maxplayers`, `minplaytime`, `maxplaytime`, `age`, `designer`, `artist` with new names and types for better clarity.
   - Updated `toString` method to reflect these changes.

10. lib/components/others_widgets/ad_list_view/widgets/dismissible_ad.dart
    - Added a `FIXME` comment to indicate the need to select direction to disable unnecessary shifts.

11. lib/features/bgg_search/bgg_search_screen.dart
    - Replaced `BigButton` with `OverflowBar` to allow more granular control of buttons like `Selecionar` and `Cancelar`.

12. lib/features/bgg_search/widgets/bg_info_card.dart
    - Reorganized UI layout in `BGInfoCard`, added image display, and adjusted text fields with new board game properties.
    - Improved layout responsiveness and added `TextOverflow.ellipsis` to designer and artist fields.

13. lib/features/boardgames/boardgame_controller.dart
    - Updated method `loadBoardInfo` to accommodate new property names for board game details.

14. lib/features/edit_ad/edit_ad_controller.dart
    - Removed `bggId` handling from the ad editing logic.
    - Updated properties to use new naming conventions like `publishYear`, `minPlayers`, `maxPlayers`, etc.

15. lib/repository/ad_repository.dart
    - Removed deprecated `bggId` from the ad repository.
    - Added logic to save additional properties such as `yearpublished`, `minplayers`, `maxplayers`, `minplaytime`, `maxplaytime`, `age`, `designer`, and `artist`.

16. lib/repository/bgg_xmlapi_repository.dart
    - Included `image` property in the parsing logic.
    - Removed unnecessary properties and refined model creation logic for `BoardgameModel`.

17. lib/repository/boardgame_repository.dart
    - Added new repository class `BoardgameRepository` to handle CRUD operations for board games.

18. lib/repository/common/constants.dart
    - Added constants related to `BoardgameModel` to handle new properties.

19. lib/repository/common/parse_to_model.dart
    - Added parsing logic for `BoardgameModel`.
    - Removed `bggId` related parsing from ad model creation.

20. pubspec.yaml
    - Renamed project from `xlo_mobx` to `bgbazzar`.
    - Added `equatable` package dependency.

21. test/common/abstracts/data_result_test.dart
    - Added test cases for `DataResult` class, including success, failure, and edge cases.

22. test/repository/ibge_repository_test.dart
    - Updated import path from `xlo_mobx` to `bgbazzar`.

23. web/index.html
    - Renamed project references from `xlo_parse_server` to `bgbazzar`.

24. web/manifest.json
    - Updated `name` and `short_name` from `xlo_parse_server` to `bgbazzar`.

The project has been successfully refactored to transition from `xlo_parse_server` to `bgbazzar`, with corresponding updates across all relevant files.

## 2024/08/09 - version: 0.6.9+32

Integrated Boardgame Functionality and Enhanced AdModel Structure

1. lib/common/models/ad.dart
   - Imported `boardgame.dart`.
   - Updated `AdModel`:
     - Changed `owner` to be nullable.
     - Added `boardgame`, `yearpublished`, `minplayers`, `maxplayers`, `minplaytime`, `maxplaytime`, `age`, `designer`, and `artist` fields.
     - Modified the constructor to initialize the new fields.
     - Updated `toString` method to include the new fields.

2. lib/common/models/bgg_boards.dart
   - Created `BGGBoardsModel` class with `objectid`, `name`, and `yearpublished` fields.

3. lib/common/models/boardgame.dart
   - Updated `BoardgameModel`:
     - Added new nullable fields `id`, `designer`, and `artist`.
     - Renamed `boardgamemechanic` to `mechanics`.
     - Renamed `boardgamecategory` to `categories`.
     - Removed `toMap` and `fromMap` methods.

4. lib/components/others_widgets/ad_list_view/widgets/ad_card_view.dart
   - Updated `AdCardView`:
     - Made `address` fields nullable when accessing `city` and `state`.

5. lib/components/others_widgets/shop_grid_view/widgets/ad_shop_view.dart
   - Updated `AdShopView`:
     - Made `owner` nullable when accessing `name`.

6. lib/features/bgg_search/bgg_search_controller.dart
   - Created `BggController`:
     - Added state management for BGG search and selection.
     - Implemented search functionality using `BggXMLApiRepository`.
     - Added methods to handle errors and fetch board game details.

7. lib/features/bgg_search/bgg_search_screen.dart
   - Created `BggSearchScreen`:
     - Implemented UI for searching and displaying BGG board games.
     - Integrated `BggController` for state management and data handling.

8. lib/features/bgg_search/bgg_search_state.dart
   - Created state classes for BGG search:
     - Added `BggSearchStateInitial`, `BggSearchStateLoading`, `BggSearchStateSuccess`, and `BggSearchStateError`.

9. lib/features/bgg_search/widgets/bg_info_card.dart
   - Created `BGInfoCard` widget:
     - Displays detailed information about a selected board game.

10. lib/features/bgg_search/widgets/search_card.dart
    - Created `SearchCard` widget:
      - Displays a list of search results from BGG.

11. lib/features/boardgames/boardgame_controller.dart
    - Updated `BoardgameController`:
      - Added disposal for additional controllers.
      - Adjusted `getBggInfo` to handle new mechanics field in `BoardgameModel`.

12. lib/features/boardgames/boardgame_screen.dart
    - Updated `BoardgamesScreen`:
      - Added BGG search button and navigation to `BggSearchScreen`.
      - Disposed of `BoardgameController` properly.

13. lib/features/edit_ad/edit_ad_controller.dart
    - Updated `EditAdController`:
      - Integrated `BoardgameModel` data into Ad creation and editing.
      - Added `setBggInfo` method to apply board game information to an ad.

14. lib/features/edit_ad/widgets/ad_form.dart
    - Updated `AdForm`:
      - Added functionality to fetch and apply BGG information using the new BGG search feature.

15. lib/features/product/product_screen.dart
    - Updated `ProductScreen`:
      - Made `owner` and `address` fields nullable when accessed.

16. lib/features/product/widgets/description_product.dart
    - Updated `DescriptionProduct`:
      - Changed subtitle text to "Descrição:".

17. lib/features/product/widgets/sub_title_product.dart
    - Updated `SubTitleProduct`:
      - Adjusted the font size and style for subtitles.

18. lib/my_material_app.dart
    - Added route for `BggSearchScreen`.

19. lib/repository/ad_repository.dart
    - Updated `AdRepository`:
      - Made `address` fields nullable when saving and updating ads.

20. lib/repository/bgg_xmlapi_repository.dart
    - Updated `BggXMLApiRepository`:
      - Added methods to fetch and parse board game data from BGG XML API.
      - Created a search method to retrieve board games by name.

This commit enhances the application by integrating Boardgame functionality into the Ad model, allowing for more detailed and relevant data management.



## 2024/08/09 - version: 0.6.8+31

Refactor `AdvertModel` to `AdModel` Across Project Files

This commit refactors the codebase by renaming `AdvertModel` to `AdModel`, ensuring consistency and clarity in the model naming convention throughout the project. Modified Files and Changes:

1. `lib/common/basic_controller/basic_controller.dart`
   - Renamed `AdvertModel` references to `AdModel`.

2. `lib/common/models/advert.dart` → `lib/common/models/ad.dart`
   - Renamed the file from `advert.dart` to `ad.dart`.
   - Updated class name from `AdvertModel` to `AdModel`.
   - Renamed `AdvertStatus` to `AdStatus`.

3. `lib/common/models/filter.dart`
   - Updated import statement from `advert.dart` to `ad.dart`.

4. `lib/components/custom_drawer/custom_drawer.dart`
   - Renamed navigation functions from `EditAdvertScreen` to `EditAdScreen`.

5. `lib/components/others_widgets/ad_list_view/ad_list_view.dart`
   - Updated all references of `AdvertModel` to `AdModel`.
   - Updated status references from `AdvertStatus` to `AdStatus`.

6. `lib/features/address/address_controller.dart`
   - Updated repository references from `AdvertRepository` to `AdRepository`.

7. `lib/features/address/address_screen.dart`
   - Updated repository references from `AdvertRepository` to `AdRepository`.

8. `lib/features/edit_advert/edit_advert_controller.dart` → `lib/features/edit_ad/edit_ad_controller.dart`
   - Renamed file and updated references from `AdvertModel` to `AdModel`.
   - Updated repository references from `AdvertRepository` to `AdRepository`.

9. `lib/features/edit_advert/edit_advert_screen.dart` → `lib/features/edit_ad/edit_ad_screen.dart`
   - Renamed file and updated references from `AdvertModel` to `AdModel`.

10. `lib/features/edit_advert/edit_advert_state.dart` → `lib/features/edit_ad/edit_ad_state.dart`
    - Renamed file and updated references from `EditAdvertState` to `EditAdState`.

11. `lib/features/edit_advert/widgets/advert_form.dart` → `lib/features/edit_ad/widgets/ad_form.dart`
    - Renamed file and updated form references from `AdvertForm` to `AdForm`.

12. `lib/features/favorites/favorites_controller.dart`
    - Updated model references from `AdvertModel` to `AdModel`.

13. `lib/features/filters/filters_controller.dart`
    - Updated import statements and model references.

14. `lib/features/my_ads/my_ads_controller.dart`
    - Updated model and repository references to `AdModel` and `AdRepository`.

15. `lib/features/my_ads/my_ads_screen.dart`
    - Updated navigation and model references to `EditAdScreen` and `AdModel`.

16. `lib/features/product/product_screen.dart`
    - Updated model references from `AdvertModel` to `AdModel`.

17. `lib/features/shop/shop_controller.dart`
    - Updated repository and model references to `AdRepository` and `AdModel`.

18. `lib/my_material_app.dart`
    - Updated routing references from `EditAdvertScreen` to `EditAdScreen`.
    - Updated model references from `AdvertModel` to `AdModel`.

19. `lib/repository/advert_repository.dart` → `lib/repository/ad_repository.dart`
    - Renamed file and updated all function references from `AdvertModel` to `AdModel`.

20. `lib/repository/common/constants.dart`
    - Updated constants related to `Advert` to reflect the `Ad` naming convention.

21. `lib/repository/common/parse_to_model.dart`
    - Updated parsing functions to reference `AdModel` instead of `AdvertModel`.

22. `lib/repository/favorite_repository.dart`
    - Updated repository and model references to `AdModel` and `AdRepository`.

This commit is part of the ongoing effort to maintain consistency in the codebase by standardizing model naming conventions.

Note: This refactor only changes the naming conventions and does not introduce any new features or functionality.


The changes introduced in this commit ensure a consistent naming convention across the codebase, improving code readability and maintainability. The model `AdvertModel` is now consistently referred to as `AdModel`, and related classes, files, and references have been updated accordingly. This refactor is crucial for future scalability and ease of understanding for developers working on the project.


## 2024/08/08 - version: 0.6.7+30

Refactor and Add New Features

1. assets/data/bgg.db
   - Updated the database binary file with new data.

2. lib/common/models/boardgame.dart
   - Changed `description` from `final` to a mutable field.
   - Updated `fromMap` method to use `cleanDescription` for `description` field.
   - Added `cleanDescription` method to sanitize and format the description text.

3. lib/components/buttons/big_button.dart
   - Renamed `onPress` callback to `onPressed` for consistency.

4. lib/components/custon_field_controllers/numeric_edit_controller.dart
   - Created a new `NumericEditController` class to manage numeric input with validation.

5. lib/components/form_fields/custom_names_form_field.dart
   - Added `onSubmitted` callback to handle form submission events.

6. lib/components/others_widgets/spin_box_field.dart
   - Created a new `SpinBoxField` widget for numeric input with increment and decrement functionality.

7. lib/features/boardgames/boardgame_controller.dart
   - Refactored to replace `bggName` with `nameController`.
   - Added controllers for various board game properties (`minPlayersController`, `maxPlayersController`, etc.).
   - Implemented `loadBoardInfo` method to populate controllers from `BoardgameModel`.
   - Adjusted `getBggInfo` to load board game information into the controller.

8. lib/features/boardgames/boardgame_screen.dart
   - Integrated new controllers and widgets (`SpinBoxField`, `SubTitleProduct`) for enhanced UI and interaction.
   - Refactored `AppBar` to include a back button.

9. lib/features/edit_advert/edit_advert_screen.dart
   - Renamed `onPress` to `onPressed` for consistency in `BigButton` usage.
   - Adjusted button labels for better clarity.

10. lib/features/edit_advert/widgets/advert_form.dart
    - Integrated `BigButton` for navigation to `BoardgamesScreen`.
    - Updated label text to clarify the input fields.

11. lib/features/filters/filters_screen.dart
    - Renamed `onPress` to `onPressed` for consistency in `BigButton` usage.

12. lib/features/login/login_screen.dart
    - Renamed `onPress` to `onPressed` for consistency in `BigButton` usage.

13. lib/features/login/widgets/login_form.dart
    - Renamed `onPress` to `onPressed` for consistency in `BigButton` usage.

14. lib/features/my_data/my_data_screen.dart
    - Renamed `onPress` to `onPressed` for consistency in `BigButton` usage.

15. lib/features/product/widgets/sub_title_product.dart
    - Added support for custom colors and padding in `SubTitleProduct`.

16. lib/features/signup/signup_screen.dart
    - Renamed `onPress` to `onPressed` for consistency in `BigButton` usage.

17. lib/features/signup/widgets/signup_form.dart
    - Renamed `onPress` to `onPressed` for consistency in `BigButton` usage.

18. lib/manager/mechanics_manager.dart
    - Added `namesFromIdListString` method to convert list of mechanic IDs to a comma-separated string.

19. lib/repository/bgg_rank_repository.dart
    - Removed instance of `BggRankStore` and used static methods instead.

20. lib/repository/bgg_xmlapi_repository.dart
    - Used `BoardgameModel.cleanDescription` to sanitize the description text from the XML API.

21. lib/repository/common/constants.dart
    - Corrected table names from `AdSale` to `AdsSale` and from `Favorite` to `Favorites`.
    - Added constants for database version management.

22. lib/repository/common/parse_to_model.dart
    - Cleaned up commented-out code related to mechanics parsing.

23. lib/repository/mechanic_repository.dart
    - Removed instance of `MechStore` and used static methods instead.

24. lib/store/bgg_rank_store.dart
    - Changed all methods to static and updated method signatures accordingly.

25. lib/store/constants/constants.dart
    - Added constants related to database versioning.

26. lib/store/database_manager.dart
    - Refactored to include database version checking and copying logic.
    - Introduced `_copyBggDb` and `getDBVerion` methods for better database management.

27. lib/store/mech_store.dart
    - Changed all methods to static and updated method signatures accordingly.

This commit includes multiple refactors and feature additions, particularly focused on improving the consistency of the codebase and adding new UI components.


2024/08/08 - version: 0.6.6+29

This commit introduces significant enhancements and new functionalities related to BGG ranks and board games, improving the overall functionality and user experience.


1. Makefile
   - Added `git add .` to `git_diff` target.
   - Modified `git_push` to include `git add .` and changed commit file from `commit.txt` to `commit`.

2. lib/common/models/advert.dart
   - Imported `foundation.dart`.
   - Added `bggId` field to `AdvertModel`.
   - Modified constructor to include `bggId`.
   - Updated `toString` method to include `bggId`.

3. lib/common/models/bgg_rank.dart
   - Created new model `BggRankModel` with fields `id`, `gameName`, `yearPublished`, `rank`, `bayesAverage`, `average`, `usersRated`, `isExpansion`, `abstractsRank`, `cgsRank`, `childrensGamesrank`, `familyGamesRank`, `partyGamesRank`, `strategyGamesRank`, `thematicRank`, `warGamesRank`.
   - Added factory methods `fromMap` and `toMap`.
   - Implemented `toString` method.

4. lib/common/models/boardgame.dart
   - Created new model `BoardgameModel` with fields `name`, `yearpublished`, `minplayers`, `maxplayers`, `minplaytime`, `maxplaytime`, `age`, `description`, `average`, `bayesaverage`, `averageweight`, `boardgamemechanic`, `boardgamecategory`.
   - Added factory methods `fromMap` and `toMap`.
   - Implemented `toString` method.

5. lib/components/form_fields/custom_form_field.dart
   - Added `suffixText` and `prefixText` parameters.
   - Updated constructor to include `suffixText` and `prefixText`.
   - Modified `build` method to use `suffixText` and `prefixText`.

6. lib/components/form_fields/custom_names_form_field.dart
   - Created new widget `CustomNamesFormField`.
   - Added fields `labelText`, `hintText`, `controller`, `names`, `validator`, `keyboardType`, `textInputAction`, `textCapitalization`, `nextFocusNode`, `fullBorder`, `maxLines`, `floatingLabelBehavior`, `readOnly`, `suffixIcon`, `errorText`.
   - Implemented `StatefulWidget` logic to show suggestions based on input.

7. lib/components/others_widgets/state_error_message.dart
   - Added `closeDialog` callback to `StateErrorMessage`.
   - Updated constructor to include `closeDialog`.
   - Added a button to close the dialog.

8. lib/features/address/address_controller.dart
   - Added `closeErroMessage` method to change state to `AddressStateSuccess`.

9. lib/features/address/address_screen.dart
   - Replaced `ButtonBar` with `OverflowBar`.
   - Updated to use `StateErrorMessage` with `closeDialog` callback.

10. lib/features/address/widgets/destiny_address_dialog.dart
    - Replaced `ButtonBar` with `OverflowBar`.

11. lib/features/boardgames/boardgame_controller.dart
    - Created `BoardgameController` with `BoardgameState`, `rankManager`, and `bggName`.
    - Added methods to handle BGG rank initialization and fetching.

12. lib/features/boardgames/boardgame_screen.dart
    - Created `BoardgamesScreen` to display board game details.
    - Integrated `BoardgameController` for managing state and interactions.

13. lib/features/boardgames/boardgame_state.dart
    - Created `BoardgameState` abstract class with `BoardgameStateInitial`, `BoardgameStateLoading`, `BoardgameStateSuccess`, and `BoardgameStateError`.

14. lib/features/edit_advert/edit_advert_controller.dart
    - Added `bggName` and `rankManager` fields.
    - Modified `init` method to include `bggName`.
    - Updated methods to handle `bggId`.

15. lib/features/edit_advert/edit_advert_screen.dart
    - Replaced `ButtonBar` with `OverflowBar`.
    - Added navigation to `BoardgamesScreen`.

16. lib/features/edit_advert/widgets/advert_form.dart
    - Added `CustomFormField` for board game name.
    - Added button to navigate to `BoardgamesScreen`.

17. lib/features/login/login_controller.dart
    - Added `closeErroMessage` method to change state to `LoginStateSuccess`.

18. lib/features/login/login_screen.dart
    - Updated controller usage to match naming conventions.

19. lib/features/mecanics/mecanics_screen.dart
    - Replaced `ButtonBar` with `OverflowBar`.

20. lib/features/my_ads/my_ads_controller.dart
    - Added `closeErroMessage` method to change state to `BasicStateSuccess`.

21. lib/features/my_ads/my_ads_screen.dart
    - Updated to use `StateErrorMessage` with `closeDialog` callback.

22. lib/features/new_address/new_address_screen.dart
    - Replaced `ButtonBar` with `OverflowBar`.

23. lib/features/shop/shop_controller.dart
    - Added `closeErroMessage` method to change state to `BasicStateSuccess`.

24. lib/features/shop/shop_screen.dart
    - Updated to use `StateErrorMessage` with `closeDialog` callback.

25. lib/get_it.dart
    - Registered `BggRankManager` in dependency injection.

26. lib/manager/bgg_rank_manager.dart
    - Created `BggRankManager` to handle BGG rank data fetching and management.

27. lib/my_material_app.dart
    - Added route for `BoardgamesScreen`.

28. lib/repository/advert_repository.dart
    - Updated to set `bggId` in `AdvertRepository`.

29. lib/repository/bgg_rank_repository.dart
    - Created `BggRankRepository` for interacting with BGG rank data.

30. lib/repository/bgg_xmlapi_repository.dart
    - Created `BggXMLApiRepository` to fetch and parse BGG XML API data.

31. lib/repository/common/constants.dart
    - Added `keyAdvertBggId`.

32. lib/repository/common/parse_to_model.dart
    - Updated to parse `bggId` in `AdvertModel`.

33. lib/store/bgg_rank_store.dart
    - Created `BggRankStore` for database interactions related to BGG ranks.

34. lib/store/constants/constants.dart
    - Updated constant `rankGameName`.

35. lib/store/mech_store.dart
    - Added spacing for readability.

36. pubspec.yaml
    - Added `xml` dependency for XML parsing.

37. lib/common/models/advert.dart
    - Added import for `foundation.dart` to support `listEquals`.

38. lib/features/address/widgets/destiny_address_dialog.dart
    - Replaced `ButtonBar` with `OverflowBar` for consistent UI.

39. lib/features/boardgames/boardgame_screen.dart
    - Improved layout and added detailed fields for board game information.

40. lib/features/edit_advert/edit_advert_screen.dart
    - Enhanced form validation and user feedback for better user experience.

41. lib/features/my_ads/my_ads_screen.dart
    - Added proper handling of error messages using `StateErrorMessage`.

42. lib/features/new_address/new_address_screen.dart
    - Updated UI components for better usability.

43. lib/repository/advert_repository.dart
    - Improved error handling and added support for `bggId`.

44. lib/repository/bgg_xmlapi_repository.dart
    - Added comprehensive error logging to facilitate debugging.

45. lib/store/bgg_rank_store.dart
    - Optimized database queries for better performance.

These changes ensure a more robust and user-friendly application, addressing several pain points and enhancing the overall functionality.

Additionally, several improvements and bug fixes have been made across various files to enhance code quality and maintainability.


## 2024/08/06 - version: 0.6.5+28

Implement Favorite Button and User-Specific Features, Improve Scrolling and Mechanics Handling

The favorite button now appears only for logged-in users and is positioned over the product images in the current layout. On the "My Ads" page, buttons to edit and delete an ad are available, but only for ads with a pending or sold status. Active products cannot be edited or deleted. In the ShopScreen, reactivity has been added to adjust the display of favorites and the page header name based on whether the user is logged in or not.

Scrolling adjustments have been made to the ShopGridView and AdListView widgets to ensure smoother scrolling when loading new ads. The control of mechanics has been migrated from the Parse server to a local SQLite database. These mechanics consist of relatively static information that does not change frequently, hence they have been incorporated into the app. Data from BGG and the annual ranking table have also been integrated into the application.

These changes enhance user-specific features and optimize the handling of mechanics by migrating data control to a local SQLite database. The integration of user-specific features and the optimization of mechanics handling ensure a more efficient and user-friendly experience. This set of changes introduces significant improvements to user interactions, performance enhancements, and the transition to local storage for mechanics, providing a more robust and efficient application experience.

Deletions primarily focus on removing configuration files and setups specific to Flutter's macOS, windows and Linux descktop implementations, cleaning up the project and reducing dependencies. Additional deletions continue the clean-up process by removing configuration files and assets specific to the macOS platform, further simplifying the project and focusing on the core Flutter application. The final batch of deletions completes the removal of configuration files, scripts, and assets specific to the macOS and Windows platforms. This clean-up aligns the project with the focus on core Flutter application development, eliminating unnecessary platform-specific files.

Below is a breakdown of the changes:

1. .env
   - Added environment variables for Parse Server configuration:
     - `PARSE_SERVER_DATABASE_URI`
     - `PARSE_SERVER_APPLICATION_ID`
     - `PARSE_SERVER_MASTER_KEY`
     - `PARSE_SERVER_CLIENT_KEY`
     - `PARSE_SERVER_JAVASCRIPT_KEY`
     - `PARSE_SERVER_REST_API_KEY`
     - `PARSE_SERVER_FILE_KEY`
     - `PARSE_SERVER_URL`
     - `PARSE_SERVER_MASTER_KEY_IPS`
     - `PARSE_PORT`

2. assets/data/bgg.db
   - Added SQLite database file for mechanics and rank data.

3. docker-compose.yml
   - Updated Parse Server configuration to use environment variables.

4. lib/common/models/advert.dart
   - Changed `mechanicsId` type from `List<String>` to `List<int>`.

5. lib/common/models/filter.dart
   - Changed `mechanicsId` type from `List<String>` to `List<int>`.

6. lib/common/models/mechanic.dart
   - Updated `MechanicModel` class:
     - Changed `id` type from `String?` to `int?`.
     - Changed `name` type from `String?` to `String`.
     - Added methods `toMap` and `fromMap`.

7. lib/common/settings/local_server.dart
   - Updated Parse Server URL and keys for back4app.com.

8. lib/components/others_widgets/ad_list_view/ad_list_view.dart
   - Removed `ButtonBehavior` enum.
   - Updated item button logic for ads:
     - Added `_editButton` and `_deleteButton` methods.
     - Added `_showAd` method for navigation.
     - Added logic to show buttons based on `buttonBehavior` flag.
   - Improved scrolling behavior:
     - Renamed `_scrollListener2` to `_scrollListener`.
     - Added `_isScrolling` flag to prevent multiple requests.

9. lib/components/others_widgets/shop_grid_view/shop_grid_view.dart
   - Improved scrolling behavior:
     - Renamed `_scrollListener2` to `_scrollListener`.
     - Added `_isScrolling` flag to prevent multiple requests.

10. lib/components/others_widgets/shop_grid_view/widgets/ad_shop_view.dart
    - Display favorite button for logged-in users only:
      - Added `isLogged` getter.
      - Used `FavStackButton` if user is logged in.

11. lib/features/edit_advert/edit_advert_controller.dart
    - Changed `selectedMechIds` type from `List<String>` to `List<int>`.

12. lib/features/edit_advert/widgets/advert_form.dart
    - Updated mechanics ID handling.

13. lib/features/filters/filters_controller.dart
    - Changed `selectedMechIds` type from `List<String>` to `List<int>`.

14. lib/features/filters/filters_screen.dart
    - Updated mechanics ID handling.

15. lib/features/mecanics/mecanics_screen.dart
    - Changed `selectedIds` type from `List<String>` to `List<int>`.

16. lib/features/my_account/my_account_screen.dart
    - Fixed logout behavior:
      - Moved `currentUser.logout()` to after `Navigator.pop`.

17. lib/features/my_ads/my_ads_screen.dart
    - Added loading and error states:
      - Used `StateLoadingMessage` and `StateErrorMessage` components.

18. lib/features/my_ads/widgets/my_tab_bar_view.dart
    - Simplified item button logic:
      - Removed `getItemButton` method.
      - Used boolean flag for `buttonBehavior`.

19. lib/features/product/product_screen.dart
    - Display favorite button in product images for logged-in users:
      - Added `isLogged` getter.
      - Used `FavStackButton` in `Stack`.

20. lib/features/shop/shop_controller.dart
    - Added listeners for user login status to update ads and page title.

21. lib/get_it.dart
    - Registered `DatabaseManager` singleton.

22. lib/manager/mechanics_manager.dart
    - Changed `mechanicsId` type from `List<String>` to `List<int>`.
    - Updated `nameFromId` method to use `int` type.

23. lib/repository/advert_repository.dart
    - Changed `mechanicsId` type from `List<String>` to `List<int>` in ad saving methods.

24. lib/repository/common/constants.dart
    - Increased `maxAdsPerList` from 6 to 20.

25. lib/repository/common/parse_to_model.dart
    - Changed `mechanicsId` type from `List<String>` to `List<int>` in ad parsing method.

26. lib/repository/mechanic_repository.dart
    - Refactored to use local SQLite database for mechanics data:
      - Used `MechStore` for querying mechanics.

27. lib/store/constants/constants.dart
    - Added constants for SQLite database handling:
      - Database name, version, and table/column names.

28. lib/store/database_manager.dart
    - Implemented database manager for initializing and handling SQLite database.

29. lib/store/mech_store.dart
    - Implemented mechanics store for querying mechanics data from SQLite database.

30. lib/components/others_widgets/fav_button.dart
    - Created `FavStackButton` widget to handle favorite actions:
      - Displays favorite icon based on whether the ad is favorited.
      - Toggles favorite status on button press.

31. lib/repository/mechanic_repository.dart.parse
    - Added legacy Parse Server mechanic repository code for reference:
      - Fetches mechanics from Parse Server.
      - Logs errors if the query fails.

32. linux/.gitignore
    - Removed unused Linux build directory from version control.

33. linux/CMakeLists.txt
    - Removed unused Linux build configuration file.

34. lib/common/settings/local_server.dart
    - Commented out back4app.com configuration details:
      - Removed hard-coded application ID and client key.
      - Defined new application ID and client key for back4app.com.
      - Set Parse Server URL to back4app.com.

35. lib/components/others_widgets/ad_list_view/ad_list_view.dart
    - Updated `AdListView` to include new button behavior:
      - Added `_editButton` and `_deleteButton` methods.
      - Modified `_scrollListener` for smoother scrolling.
      - Updated layout to include edit and delete buttons for ads.

36. lib/components/others_widgets/shop_grid_view/shop_grid_view.dart
    - Updated `ShopGridView` for better scrolling performance:
      - Modified `_scrollListener` for smoother scrolling.
      - Added `_isScrolling` to prevent duplicate load calls.

37. lib/features/my_ads/my_ads_screen.dart
    - Enhanced `MyAdsScreen` to display loading and error messages:
      - Added `StateLoadingMessage` and `StateErrorMessage` for better state handling.

38. lib/features/product/product_screen.dart
    - Improved `ProductScreen` to include favorite button for logged-in users:
      - Added `FavStackButton` to the `ImageCarousel` stack.

39. lib/repository/common/constants.dart
    - Increased `maxAdsPerList` from 6 to 20 to display more ads per load.

40. lib/store/database_manager.dart
    - Created `DatabaseManager` to handle local SQLite database:
      - Initializes database from assets if not found.
      - Provides methods to access and close the database.

41. lib/store/mech_store.dart
    - Created `MechStore` to handle mechanics storage:
      - Queries mechanics from local SQLite database.
      - Fetches mechanic descriptions based on language code.

42. linux/*
    - Removed linux desktop support.

43. macos/*
    - Removed macOS descktop support.
      
44. windows/*
    - Removed Windows desktop support.
      
45. pubspec.yaml
    - Modified file.
      - Added `sqflite` and `path_provider` to dependencies.
      - Included assets for the project.

These changes enhance user-specific features and optimize the handling of mechanics by migrating data control to a local SQLite database. This set of changes introduces significant improvements to user interactions and performance, ensuring a more efficient and user-friendly experience. The transition to local storage for mechanics provides a more robust and efficient application experience.

Deletions primarily focus on removing configuration files and setup specific to Flutter's macOS and Linux implementations, cleaning up the project and reducing dependencies. Remaining deletions continue the clean-up process by removing additional configuration files and assets specific to the macOS platform, further simplifying the project and focusing on the core Flutter application. The final batch of deletions completes the removal of configuration files, scripts, and assets specific to the macOS and Windows platforms, aligning the project with the focus on core Flutter application development and eliminating unnecessary platform-specific files.


## 2024/08/01 - version: 0.6.2+27

This commit introduces multiple enhancements and fixes across various components of the project:

1. **`Makefile`**
   - Added a new `build_profile` target for running the Flutter app in profile mode.

2. **`README.md`**
   - Updated the TODO list and removed unnecessary sections to streamline the document.

3. **`analysis_options.yaml`**
   - Configured the analyzer to treat deprecated member use as an error.

4. **`android/app/build.gradle`**
   - Updated `compileSdk`, `minSdk`, and `targetSdk` versions to 34 and 21 respectively.
   
5. **`android/app/src/main/AndroidManifest.xml`**
   - Added necessary permissions for internet, camera, and external storage access.

6. **`android/build.gradle`**
   - Updated the Gradle plugin version to 8.5.0.

7. **`android/gradle/wrapper/gradle-wrapper.properties`**
   - Updated the Gradle distribution URL to use version 8.5.

8. **`flutter_01.png`**
   - Added a new image resource.

9. **`lib/common/app_constants.dart`**
   - Introduced a new constant `appTitle` with the value 'BGBazzar'.

10. **`lib/common/singletons/search_filter.dart`**
    - Refactored the `SearchFilter` class, removing redundant code and adding a `haveFilter` getter.

11. **`lib/common/singletons/search_history.dart`**
    - Refactored the `SearchHistory` class, removing redundant code and optimizing methods.

12. **`lib/components/custom_drawer/custom_drawer.dart`**
    - Added navigation methods and refactored the code to improve readability and functionality.

13. **`lib/components/others_widgets/shop_grid_view/widgets/ad_shop_view.dart`**
    - Adjusted the image size calculation for better UI consistency.

14. **`lib/features/base/base_controller.dart`, `lib/features/base/base_screen.dart`, `lib/features/base/base_state.dart`, `lib/features/base/widgets/old/search_dialog_bar.dart`, `lib/features/base/widgets/old/search_dialog_search_bar.dart`, `lib/features/base/widgets/search_controller.dart`**
    - Deleted obsolete files related to the base controller and screen.

15. **`lib/features/favorites/favorites_controller.dart`**
    - Removed TODO comments and unimplemented methods.

16. **`lib/features/login/login_screen.dart`**
    - Added a back button to the app bar.

17. **`lib/features/my_account/my_account_screen.dart`**
    - Refactored the logout method and fixed a comment for the logout feature.

18. **`lib/features/product/product_screen.dart`**
    - Added a comment for the favorite button functionality.

19. **`lib/features/shop/shop_controller.dart`**
    - Major refactor, including new methods for setting the page title, cleaning search, and handling ads retrieval.

20. **`lib/features/shop/shop_screen.dart`**
    - Refactored the shop screen, including the app bar, floating action button, and the main content area for better UX and code maintainability.

21. **`lib/features/shop/shop_state.dart`**
    - Deleted the redundant shop state file.

22. **`lib/features/base/widgets/search_dialog.dart` -> `lib/features/shop/widgets/search/search_dialog.dart`**
    - Renamed and refactored the search dialog for better modularity.

23. **`lib/features/signup/signup_screen.dart`**
    - Added a back button to the app bar.

24. **`lib/get_it.dart`**
    - Updated dependency registration, replacing `BaseController` with `ShopController`.

25. **`lib/my_material_app.dart`**
    - Changed the initial route to `ShopScreen`.

26. **`pubspec.lock`, `pubspec.yaml`**
    - Updated `shared_preferences` package to version 2.3.0.

These changes collectively improve the project’s structure, enhance user experience, and maintain code consistency.


## 2024/08/01 - version: 0.6.1+25

This commit introduces the Favorites feature and refactors various components to enhance functionality and code organization:

1. **`lib/components/custom_drawer/custom_drawer.dart`**
   - Imported `FavoritesScreen` to enable navigation.
   - Updated the "Favoritos" list tile to use `Navigator.pushNamed` for navigation.

2. **`lib/features/base/base_controller.dart`**
   - Removed "Favoritos" from the `titles` list.

3. **`lib/features/base/base_screen.dart`**
   - Removed the `FavoritesScreen` from the list of screens managed by `BaseScreen`.

4. **`lib/features/favorites/favorites_controller.dart`**
   - New file: Added `FavoritesController` to manage the state and data of the Favorites feature.

5. **`lib/features/favorites/favorites_screen.dart`**
   - Implemented the `FavoritesScreen` with state management and display logic using `FavoritesController` and `ShopGridView`.

6. **`lib/features/shop/shop_screen.dart`**
   - Removed the `showImage` method as it is now redundant with the `ShopGridView` implementation.

7. **`lib/get_it.dart`**
   - Added disposal of `FavoritesManager` in the `disposeDependencies` method.

8. **`lib/manager/favorites_manager.dart`**
   - Added the `ads` getter to expose the list of favorite ads.
   - Added a `dispose` method to properly clean up the `favNotifier`.

9. **`lib/my_material_app.dart`**
   - Added a route for `FavoritesScreen` in the route table.

10. **`pubspec.yaml`**
    - Updated the version from `0.6.1+26` to `0.6.2+27`.

These changes collectively add the Favorites feature, allowing users to manage and view their favorite ads. The code refactoring improves maintainability and clarity.


## 2024/07/31 - version: 0.6.1+25

This commit introduces updates, new functionalities, and refactorings across multiple files to improve user management and advertisement features:

1. `lib/common/singletons/current_user.dart`
   - Added `FavoritesManager` integration for managing user favorites.
   - Renamed `isLoged` to `isLogged`.
   - Added `login` method for handling user login logic.
   - Updated `logout` method to clear user favorites and addresses.

2. `lib/components/custom_drawer/custom_drawer.dart`
   - Renamed `isLoged` to `isLogged` to ensure consistent naming.
   - Updated button interactions based on user login status.

3. `lib/components/custom_drawer/widgets/custom_drawer_header.dart`
   - Renamed `isLoged` to `isLogged` for consistency.

4. `lib/components/others_widgets/shop_grid_view/shop_grid_view.dart`
   - New file: Added `ShopGridView` widget for displaying advertisements in a grid view.

5. `lib/components/others_widgets/shop_grid_view/widgets/ad_shop_view.dart`
   - New file: Added `AdShopView` widget for displaying individual advertisements.

6. `lib/components/others_widgets/shop_grid_view/widgets/owner_rating.dart`
   - New file: Added `OwnerRating` widget to display owner ratings.

7. `lib/components/others_widgets/shop_grid_view/widgets/shop_text_price.dart`
   - New file: Added `ShopTextPrice` widget to display advertisement prices.

8. `lib/components/others_widgets/shop_grid_view/widgets/shop_text_title.dart`
   - New file: Added `ShopTextTitle` widget to display advertisement titles.

9. `lib/components/others_widgets/shop_grid_view/widgets/show_image.dart`
   - New file: Added `ShowImage` widget to handle image display.

10. `lib/features/base/base_screen.dart`
    - Renamed `isLoged` to `isLogged` to ensure consistent naming.

11. `lib/features/edit_advert/edit_advert_screen.dart`
    - Updated title to reflect editing state.
    - Added `StateLoadingMessage` and `StateErrorMessage` for better state handling.
    - Fixed controller reference in `ImagesListView`.

12. `lib/features/edit_advert/widgets/image_list_view.dart`
    - Fixed controller reference to `ctrl` for consistency.

13. `lib/features/shop/shop_screen.dart`
    - Replaced `AdListView` with `ShopGridView` for better advertisement display.

14. `lib/get_it.dart`
    - Registered `FavoritesManager` for dependency injection.

15. `lib/manager/address_manager.dart`
    - Added methods `login` and `logout` to manage user login state.

16. `lib/manager/favorites_manager.dart`
    - New file: Added `FavoritesManager` to manage user favorites, including methods to add, remove, and fetch favorites.

17. `lib/repository/constants.dart`
    - Updated `maxAdsPerList` to 6 for better pagination.

18. `lib/repository/favorite_repository.dart`
    - Updated `add` method to use `adId` directly.
    - Added `getFavorites` method to fetch user's favorite advertisements.

19. `lib/repository/parse_to_model.dart`
    - Renamed `favotire` to `favorite` for correct spelling.
    - Added type annotation for `mechanic` method.

These changes collectively enhance user management, improve advertisement handling, and introduce a new favorites feature.


## 2024/07/31 - version: 0.6.0+24

This commit introduces several updates, new functionalities, and refactorings across multiple files:

1. `lib/common/models/favorite.dart`
   - New file: Added `FavoriteModel` class to represent favorite advertisements with attributes `id` and `adId`.

2. `lib/features/address/address_controller.dart`
   - Removed unnecessary delay after deleting an address in the `moveAdsAddressAndRemove` method.

3. `lib/features/base/widgets/search_dialog_bar.dart`
   - Renamed and moved to `lib/features/base/widgets/old/search_dialog_bar.dart` for better organization.

4. `lib/features/base/widgets/search_dialog_search_bar.dart`
   - Renamed and moved to `lib/features/base/widgets/old/search_dialog_search_bar.dart` for better organization.

5. `lib/features/edit_advert/edit_advert_controller.dart`
   - Updated `mechanicsManager` to use the instance from `getIt` for dependency injection.

6. `lib/features/filters/filters_controller.dart`
   - Updated `mechManager` to use the instance from `getIt` for dependency injection.

7. `lib/features/filters/filters_screen.dart`
   - Fixed typo in the hint text from 'Cidate' to 'Cidade'.

8. `lib/features/mecanics/mecanics_screen.dart`
   - Updated `mechanics` to use the instance from `getIt` for dependency injection.

9. `lib/features/my_account/my_account_screen.dart`
   - Refactored `onPressed` method of the logout button to be asynchronous.

10. `lib/features/product/product_screen.dart`
    - Added a favorite button to the app bar for product screens.

11. `lib/features/product/widgets/image_carousel.dart`
    - Replaced `carousel_slider` with `flutter_carousel_slider` for better functionality.
    - Updated the layout and behavior of the image carousel.

12. `lib/get_it.dart`
    - Registered `MechanicsManager` as a lazy singleton for dependency injection.

13. `lib/main.dart`
    - Updated initialization process to include `MechanicsManager`.

14. `lib/manager/mechanics_manager.dart`
    - Removed singleton pattern in favor of dependency injection using `getIt`.

15. `lib/repository/constants.dart`
    - Added constants for the `Favorite` table and its fields.

16. `lib/repository/favorite_repository.dart`
    - New file: Added `FavoriteRepository` with methods to add and delete favorites.

17. `lib/repository/parse_to_model.dart`
    - Added method `favorite` to convert ParseObject to `FavoriteModel`.

18. `lib/repository/user_repository.dart`
    - Updated `update` method to handle user password changes more effectively.
    - Improved logout method to be asynchronous.

19. `pubspec.lock`
    - Removed `carousel_slider` package.
    - Added `flutter_carousel_slider` package.

20. `pubspec.yaml`
    - Removed `carousel_slider` dependency.
    - Added `flutter_carousel_slider` dependency.

These changes collectively enhance the functionality and organization of the application, improve dependency management, and introduce the capability to handle favorite advertisements.


## 2024/07/30 - version: 0.5.3+23

This commit introduces a range of updates and new functionalities across multiple files:

1. `lib/components/dialogs/simple_question.dart`
   - New file: Added `SimpleQuestionDialog` widget for displaying simple question dialogs with Yes/No or Confirm/Cancel options.

2. `lib/features/address/address_controller.dart`
   - Imported `dart:developer`.
   - Added `AddressState` management.
   - Introduced `selectesAddresId`, `_changeState`, and `moveAdsAddressAndRemove` methods for better address handling.

3. `lib/features/address/address_screen.dart`
   - Imported `dart:developer` and `state_error_message.dart`.
   - Updated `_removeAddress` to handle advertisements associated with the address.
   - Added `AnimatedBuilder` for managing loading and error states.
   - Included `DestinyAddressDialog` for handling the destination address when removing an address.

4. `lib/features/my_data/my_data_state.dart`
   - Renamed file to `lib/features/address/address_state.dart` to be consistent with the new address state management.

5. `lib/features/address/widgets/destiny_address_dialog.dart`
   - New file: Added `DestinyAddressDialog` widget for selecting a destination address when removing an address with associated advertisements.

6. `lib/features/my_ads/my_ads_screen.dart`
   - Added `floatingActionButton` for adding new advertisements.
   - Introduced `_addNewAdvert` method to navigate to the `EditAdvertScreen`.

7. `lib/features/my_data/my_data_controller.dart`
   - Removed `MyDataState` management to simplify the controller.
   - Removed `_changeState` method.

8. `lib/features/my_data/my_data_screen.dart`
   - Added `backScreen` method to handle unsaved changes.
   - Refactored the screen layout to include `SimpleQuestionDialog` for unsaved changes.

9. `lib/manager/address_manager.dart`
   - Added methods `deleteByName`, `deleteById`, and `getAddressIdFromName` for better address management.

10. `lib/repository/address_repository.dart`
    - Updated `delete` method to accept `addressId` instead of `address`.
    - Added `moveAdsAddressTo` method for moving advertisements to another address.
    - Added `adsInAddress` method to retrieve advertisements associated with a specific address.

11. `lib/repository/advert_repository.dart`
    - Updated `delete` method to accept `adId` instead of `ad`.
    - Added `moveAdsAddressTo` and `adsInAddress` methods to support address management.

12. `pubspec.yaml`
    - Updated version to `0.5.3+23`.

These changes collectively enhance the address management functionality, introduce new dialog widgets for better user interaction, and update the repository methods to handle advertisement associations with addresses.


## 2024/07/30 - version: 0.5.2+22

This commit introduces several enhancements and fixes across multiple files:

1. `lib/common/models/advert.dart`
   - Added `deleted` status to the `AdvertStatus` enum.

2. `lib/common/singletons/current_user.dart`
   - Imported `get_it.dart`.
   - Changed the initialization of `addressManager` to use `getIt<AddressManager>()`.

3. `lib/common/utils/extensions.dart`
   - Added a new extension method `onlyNumbers` to `StringExtension`.

4. `lib/common/validators/validators.dart`
   - Imported `extensions.dart`.
   - Renamed `nickname` validation method to `name`.
   - Enhanced `phone` validation to include various checks like length, area code, and valid mobile/landline number.
   - Added `DataValidator` class with methods for validating password, confirming password, name, and phone.

5. `lib/components/custom_drawer/custom_drawer.dart`
   - Removed redundant imports.
   - Updated `CustomDrawer` constructor and properties.
   - Refactored `_navToLoginScreen` method into `navToLoginScreen`.
   - Adjusted `ListTile` items to use `ctrl.jumpToPage`.

6. `lib/components/form_fields/password_form_field.dart`
   - Added `fullBorder` parameter to `PasswordFormField`.
   - Conditional application of `OutlineInputBorder`.

7. `lib/components/others_widgets/state_error_message.dart`
   - New file: Added `StateErrorMessage` widget for displaying error messages.

8. `lib/components/others_widgets/state_loading_message.dart`
   - New file: Added `StateLoadingMessage` widget for displaying loading messages.

9. `lib/features/address/address_controller.dart`
   - Changed the initialization of `addressManager` to use `getIt<AddressManager>()`.

10. `lib/features/address/address_screen.dart`
    - Disabled `_removeAddress` button and added comments for future implementation.

11. `lib/features/base/base_controller.dart`
    - Added `user` getter.
    - Refactored `jumpToPage` and `setPageTitle` methods.
    - Adjusted `titles` constant to reflect updated page titles.

12. `lib/features/base/base_screen.dart`
    - Updated `titleWidget` to use `ctrl.pageTitle`.
    - Added `navToLoginScreen` method.
    - Replaced `CircularProgressIndicator` with `StateLoadingMessage`.

13. `lib/features/login/login_screen.dart`
    - Added `StateErrorMessage` and `StateLoadingMessage` for error and loading states.
    - Threw exception for unimplemented navigation actions.

14. `lib/features/my_account/my_account_screen.dart`
    - Added imports for `AddressScreen` and `MyDataScreen`.
    - Updated `ListTile` items to use the new screens.

15. `lib/features/my_ads/my_ads_controller.dart`
    - Commented out the call to `AdvertRepository.delete` and added a status update using `AdvertRepository.updateStatus`.

16. `lib/features/my_data/my_data_controller.dart`
    - New file: Added `MyDataController` for managing user data.

17. `lib/features/my_data/my_data_screen.dart`
    - New file: Added `MyDataScreen` for displaying and editing user data.

18. `lib/features/my_data/my_data_state.dart`
    - New file: Added `MyDataState` classes for representing different states in `MyDataController`.

19. `lib/features/product/widgets/title_product.dart`
    - Added optional `color` parameter to `TitleProduct`.

20. `lib/features/shop/shop_screen.dart`
    - Added `StateErrorMessage` and `StateLoadingMessage` for error and loading states.
    - Adjusted `FloatingActionButton` behavior to reinitialize the controller after login.

21. `lib/features/signup/signup_controller.dart`
    - Renamed `nicknameController` to `nameController`.
    - Updated focus nodes and controller disposal.

22. `lib/features/signup/widgets/signup_form.dart`
    - Updated to use `nameController` and `phoneFocusNode`.

23. `lib/get_it.dart`
    - Registered `AddressManager` as a lazy singleton.

24. `lib/manager/address_manager.dart`
    - Removed singleton pattern in favor of dependency injection.

25. `lib/my_material_app.dart`
    - Added route for `MyDataScreen`.

26. `lib/repository/advert_repository.dart`
    - Updated `updateStatus` method to use `parse.update`.

27. `lib/repository/user_repository.dart`
    - Added `update` method for updating user information.

These changes collectively enhance functionality, improve code readability, and address various bugs.


## 2024/07/29 - version: 0.5.2+21

Renamed Advertisement Features and Updated Navigation

1. Updated Navigation in `lib/components/custom_drawer/custom_drawer.dart`:
   - Changed import from `AdvertScreen` to `EditAdvertScreen`.
   - Updated navigation from `AdvertScreen` to `EditAdvertScreen`.

2. Modified Navigation in `lib/features/base/base_screen.dart`:
   - Changed import from `AccountScreen` to `MyAccountScreen`.
   - Updated the last screen in `PageView` to `MyAccountScreen`.

3. Renamed Advertisement Controller and State:
   - Renamed `lib/features/advertisement/advert_controller.dart` to `lib/features/edit_advert/edit_advert_controller.dart`.
   - Renamed `AdvertController` to `EditAdvertController`.
   - Updated state management classes from `AdvertState` to `EditAdvertState`.

4. Renamed Advertisement Screen:
   - Renamed `lib/features/advertisement/advert_screen.dart` to `lib/features/edit_advert/edit_advert_screen.dart`.
   - Renamed `AdvertScreen` to `EditAdvertScreen`.

5. Updated Advertisement State Class Names:
   - Renamed `lib/features/advertisement/advert_state.dart` to `lib/features/edit_advert/edit_advert_state.dart`.
   - Updated state classes from `AdvertState` to `EditAdvertState`.

6. Updated Advertisement Form and Widgets:
   - Renamed advertisement form and widget files to `edit_advert` equivalents.

7. Renamed Account Screen:
   - Renamed `lib/features/account/account_screen.dart` to `lib/features/my_account/my_account_screen.dart`.
   - Renamed `AccountScreen` to `MyAccountScreen`.

8. Updated References in My Ads Screen:
   - Updated import and usage from `AdvertScreen` to `EditAdvertScreen`.

9. Updated Shop Screen Navigation:
   - Changed navigation from `AdvertScreen` to `EditAdvertScreen`.

10. Updated Main App Navigation:
    - Changed import and route from `AccountScreen` to `MyAccountScreen`.
    - Updated the route for advertisement screen to `EditAdvertScreen`.

These changes refactor the advertisement feature by renaming relevant files and classes for better clarity and organization. Navigation has been updated accordingly to reflect these changes.


## 2024/07/29 - version: 0.5.2+20

Enhanced Advertisement Features and Refactoring

1. `lib/common/app_constants.dart`
   - Created a new file to define the `AppPage` enum with values `shopePage`, `chatPage`, `favoritesPage`, and `accountPage` for better navigation handling.

2. `lib/components/buttons/big_button.dart`
   - Updated the button's `borderRadius` to 32 for a more rounded appearance.

3. `lib/components/custom_drawer/custom_drawer.dart`
   - Imported `AppPage` enum from `app_constants.dart` and `AdvertScreen`.
   - Replaced hard-coded page numbers with `AppPage` enum values for improved readability and maintainability.

4. `lib/components/others_widgets/ad_list_view/ad_list_view.dart`
   - Added `editAd` and `deleteAd` callbacks to handle advertisement editing and deletion.
   - Removed logging and simplified button actions to call the new callbacks.

5. `lib/features/account/account_screen.dart`
   - Imported `AppPage` enum from `app_constants.dart`.
   - Replaced hard-coded page number with `AppPage.shopePage` for navigation after logout.

6. `lib/features/advertisement/advert_controller.dart`
   - Updated `init` method to use `setSelectedAddress` for setting the address.
   - Improved `removeImage` method to handle both URL and local file deletion.
   - Added `updateAds` method to update an existing advertisement.
   - Renamed `createAnnounce` to `createAds` and adjusted its implementation.

7. `lib/features/advertisement/advert_screen.dart`
   - Added an AppBar with dynamic title based on whether the ad is new or being edited.
   - Updated `_createAnnounce` method to handle both ad creation and updating, returning to the previous screen with the updated ad.

8. `lib/features/advertisement/widgets/advert_form.dart`
   - Updated icons in `SegmentedButton` for better representation of `AdvertStatus` values.

9. `lib/features/advertisement/widgets/horizontal_image_gallery.dart`
   - Added `showImage` method to handle displaying both network and local images.
   - Adjusted `_showImageEditDialog` to show either a network or local image based on the URL pattern.

10. `lib/features/advertisement/widgets/image_list_view.dart`
    - Added `editAd` and `deleteAd` callbacks for handling ad editing and deletion.

11. `lib/features/base/base_controller.dart`
    - Imported `AppPage` enum from `app_constants.dart`.
    - Replaced `_page` type from `int` to `AppPage` for better type safety and readability.

12. `lib/features/base/base_screen.dart`
    - Imported `AppPage` enum from `app_constants.dart`.
    - Updated various navigation references to use `AppPage` enum values.

13. `lib/features/my_ads/my_ads_controller.dart`
    - Implemented `updateAd` method to refresh ads after an update.
    - Implemented `deleteAd` method to delete an advertisement and refresh the ads list.

14. `lib/features/my_ads/my_ads_screen.dart`
    - Added methods `_editAd` and `_deleteAd` to handle editing and deletion of advertisements with confirmation dialogs.
    - Updated `MyTabBarView` usage to include `editAd` and `deleteAd` callbacks.

15. `lib/features/my_ads/widgets/my_tab_bar.dart`
    - Updated icons in `Tab` widgets for better representation of advertisement statuses.

16. `lib/features/my_ads/widgets/my_tab_bar_view.dart`
    - Added `editAd` and `deleteAd` callbacks to `AdListView`.

17. `lib/features/shop/shop_screen.dart`
    - Imported `AdvertScreen`.
    - Updated `FloatingActionButton` to navigate to `AdvertScreen` for adding a new advertisement.

18. `lib/repository/advert_repository.dart`
    - Added `update` method to update an advertisement on the Parse server.
    - Improved `_saveImages` method to correctly identify URL patterns.
    - Added `delete` method to delete an advertisement from the Parse server.

These changes enhance the advertisement management features by improving navigation with the `AppPage` enum, adding capabilities for editing and deleting ads, and refining the UI components for better user experience and maintainability. The refactor also ensures the codebase is more readable and easier to manage.


## 2024/07/29 - version: 0.5.2+19

Enhanced Advertisement Features and Refactoring

1. `lib/common/models/advert.dart`
   - Reordered the `title` property to appear before `status` in the `AdvertModel` class for consistency.

2. `lib/components/custon_field_controllers/currency_text_controller.dart`
   - Added `currencyValue` setter to update the text value of the controller based on the provided currency value. This simplifies setting the currency value programmatically.

3. `lib/components/others_widgets/ad_list_view/ad_list_view.dart`
   - Imported `dart:developer` for logging purposes.
   - Added `ButtonBehavior` enum to define possible button actions (`edit`, `delete`).
   - Replaced `itemButton` parameter with `buttonBehavior` to handle different button actions dynamically.
   - Added `getItemButton` method to generate the appropriate button widget based on `buttonBehavior`.
   - Enhanced logging to include the length of ads list to aid in debugging and monitoring the list state.

4. `lib/components/others_widgets/ad_list_view/widgets/ad_card_view.dart`
   - Updated the `Card` widget with a `shape` property, applying `RoundedRectangleBorder` to provide rounded corners for better visual appeal.

5. `lib/features/advertisement/advert_controller.dart`
   - Added `init` method to initialize the controller with an `AdvertModel` instance, populating various fields like `title`, `description`, `hidePhone`, `price`, `status`, `mechanicsId`, `address`, and `images`.
   - Added `setImages` method to set the list of images in the controller, updating the `_images` list and notifying listeners.

6. `lib/features/advertisement/advert_screen.dart`
   - Updated constructor to accept an optional `AdvertModel` instance, allowing the screen to display and edit existing advertisements.
   - Added initialization of `AdvertController` with the provided `AdvertModel` instance in `initState` to pre-fill the form fields with existing data.

7. `lib/features/my_ads/my_ads_controller.dart`
   - Added placeholder methods `updateAd` and `deleteAd` with TODO comments indicating future implementation plans for updating and deleting advertisements.

8. `lib/features/my_ads/my_ads_screen.dart`
   - Refactored to replace direct usage of `TabBar` and `TabBarView` with custom widgets `MyTabBar` and `MyTabBarView` to improve code modularity and readability.
   - Added custom `MyTabBar` widget to handle tab selection and update the product status in the controller.
   - Added custom `MyTabBarView` widget to display advertisements based on their status, with configurable dismissible actions and button behaviors.

9. `lib/features/my_ads/widgets/my_tab_bar.dart`
   - Implements a custom `TabBar` widget that maps tab selection to product status changes in the `MyAdsController`.

10. `lib/features/my_ads/widgets/my_tab_bar_view.dart`
    - Implements a custom `TabBarView` widget that displays a list of advertisements with different statuses, using `AdListView` with configurable actions for each tab.

11. `lib/my_material_app.dart`
    - Updated routing logic to handle `AdvertScreen` navigation, passing an `AdvertModel` instance when navigating to allow for ad editing.
    - Simplified `onGenerateRoute` method for better readability, ensuring all routes handle their respective arguments correctly.

These changes enhance the advertisement management capabilities by adding the ability to edit and delete ads directly from the list, initializing controllers with existing ad data, and modularizing the UI components for better code organization and maintainability. The refactor also improves the overall user experience by making the UI more intuitive and the codebase easier to maintain and extend.


## 2024/07/26 - version: 0.5.2+18

Improved Advertisement Management and Code Refactoring

1. `lib/common/basic_controller/basic_controller.dart`
   - **Added**: `Future<bool> updateAdStatus(AdvertModel ad)` method to update advertisement status.

2. `lib/common/singletons/current_user.dart`
   - **Imported**: `foundation.dart` to use `ValueNotifier`.
   - **Added**: `_isLoged` as `ValueNotifier<bool>` to manage login state.
   - **Updated**: `isLoged` to use `_isLoged.value` and added `isLogedListernable` getter.
   - **Modified**: `init` method to update `_isLoged.value` upon initialization.
   - **Added**: `dispose` method to dispose of `_isLoged`.
   - **Updated**: `logout` method to set `_isLoged.value` to false.

3. `lib/components/custom_drawer/custom_drawer.dart`
   - **Updated**: Menu item text from 'Inserir Anúncio' to 'Adicionar Anúncio'.

4. `lib/features/shop/widgets/ad_list_view.dart`
   - **Renamed**: File to `lib/components/others_widgets/ad_list_view/ad_list_view.dart`.
   - **Replaced**: `ShopController` with `BasicController`.
   - **Enhanced**: `AdListView` with new parameters for dismissible ads and additional properties.

5. `lib/components/others_widgets/ad_list_view/widgets/ad_card_view.dart`
   - **New File**: Handles the display of advertisement cards with various properties.

6. `lib/components/others_widgets/ad_list_view/widgets/dismissible_ad.dart`
   - **New File**: Manages dismissible ads with customizable actions and status updates.

7. `lib/components/others_widgets/ad_list_view/widgets/show_image.dart`
   - **New File**: Manages image display with a fallback for empty images.

8. `lib/components/others_widgets/base_dismissible_container.dart`
   - **New File**: Provides a base container for dismissible actions in the UI.

9. `lib/components/others_widgets/fitted_button_segment.dart`
   - **New File**: Defines a fitted button segment for use in segmented controls.

10. `lib/features/advertisement/advert_controller.dart`
    - **Added**: `_adStatus` property and corresponding getter.
    - **Refactored**: Moved `_changeState` method to a different position.
    - **Updated**: `saveAd` method to include `status` property.
    - **Added**: `setAdStatus` method to update advertisement status.

11. `lib/features/advertisement/advert_screen.dart`
    - **Wrapped**: `AdvertForm` and `BigButton` inside a `Column` for better structure.

12. `lib/features/advertisement/widgets/advert_form.dart`
    - **Imported**: `fitted_button_segment.dart` for custom button segments.
    - **Added**: Segmented button for selecting `AdvertStatus`.

13. `lib/features/base/base_controller.dart`
    - **Updated**: Title from 'Criar Anúncio' to 'Adicionar Anúncio' for consistency.

14. `lib/features/my_ads/my_ads_controller.dart`
    - **Refactored**: `getAds` method to use a helper method `_getAds`.
    - **Added**: `_getAds` and `_getMoreAds` helper methods for better code organization.
    - **Added**: `updateAdStatus` method to handle advertisement status updates.

15. `lib/features/my_ads/my_ads_screen.dart`
    - **Enhanced**: `AdListView` to support dismissible ads with custom status updates and icons.
    - **Added**: `physics` property to `TabBarView` to disable scrolling.

16. `lib/features/shop/shop_controller.dart`
    - **Refactored**: `getAds` method to reset `_adPage` and clear ads.
    - **Added**: `updateAdStatus` method with `UnimplementedError`.

17. `lib/features/shop/shop_screen.dart`
    - **Updated**: Import path for `ad_list_view.dart`.
    - **Added**: `ValueListenableBuilder` to manage `FloatingActionButton` state based on login status.

18. `lib/features/shop/widgets/ad_text_price.dart`
    - **Removed**: Unused `colorScheme` variable.
    - **Updated**: Text style for better readability.

19. `lib/features/shop/widgets/ad_text_title.dart`
    - **Changed**: `maxLines` from 3 to 2 for better layout consistency.

20. `lib/get_it.dart`
    - **Added**: `dispose` call for `CurrentUser`.

21. `lib/my_material_app.dart`
    - **Changed**: Main font from "Poppins" to "Manrope" for a refreshed UI look.

22. `lib/repository/advert_repository.dart`
    - **Added**: `updateStatus` method to update advertisement status in the Parse server.

These changes enhance the advertisement management capabilities by adding new functionalities and refactoring the code for better maintainability and usability. The updates improve user experience and ensure consistent behavior across the application.


## 2024/07/26 - version: 0.5.1+17

This commit includes several adjustments to animations, a reduction in the number of `AdvertStatus` options, and various other enhancements to improve code consistency and functionality. Changes:

1. lib/common/models/advert.dart
   - Removed `AdvertStatus.closed` from the `AdvertStatus` enum.

2. lib/common/theme/app_text_style.dart
   - Added `font14Thin` style for thinner text with font size 14.

3. lib/features/my_ads/my_ads_controller.dart
   - Added properties `_adPage`, `_getMorePages`, and `getMorePages`.
   - Implemented logic to fetch additional pages of advertisements in `getMoreAds`.

4. lib/features/my_ads/my_ads_screen.dart
   - Updated `TabBar` length to 3 to remove the unnecessary "Fechados" tab.
   - Adjusted text styles for consistency.
   - Enhanced error and loading state handling.

5. lib/features/product/product_screen.dart
   - Adjusted `AnimationController` duration for `FloatingActionButton` to 300 milliseconds.
   - Simplified scroll notification handling logic.

6. lib/features/shop/shop_controller.dart
   - Refactored to extend `BasicController` and use `BasicState` for state management.
   - Added initialization and pagination logic for fetching advertisements.

7. lib/features/shop/shop_screen.dart
   - Refactored to integrate `BasicState` for consistent state management.
   - Updated `AnimationController` duration and scroll listener logic.
   - Improved `FloatingActionButton` animation and visibility handling.

8. lib/my_material_app.dart
   - Changed the text theme order in `createTextTheme` to prioritize "Poppins" over "Comfortaa".

9. lib/repository/advert_repository.dart
   - Removed the `maxAdsPerList` constant and relocated it to `constants.dart`.

10. lib/repository/constants.dart
    - Added `maxAdsPerList` constant and set its value to 5 for better performance during testing.

Standardized animations for `FloatingActionButton`, streamlined advertisement status options, and improved overall state management and UI consistency across various features.


## 2024/07/26 - version: 0.5.0+16

This commit introduces several new files and modifications to the existing codebase, adding functionalities and enhancements, including dependency injection with `get_it`. Changes:

1. lib/common/basic_controller/basic_controller.dart
   - Added new file with `BasicController` abstract class.
   - Defined state management and basic functionalities such as `changeState`, `init`, `getAds`, and `getMoreAds`.

2. lib/common/basic_controller/basic_state.dart
   - Added new file defining `BasicState` abstract class and its concrete implementations: `BasicStateInitial`, `BasicStateLoading`, `BasicStateSuccess`, and `BasicStateError`.

3. lib/common/models/address.dart
   - Added `import 'dart:convert';`.
   - Included `createdAt` property in `AddressModel`.
   - Modified constructor to initialize `createdAt`.
   - Updated `toString`, `==`, and `hashCode` methods to include `createdAt`.
   - Added `copyWith` method.
   - Added `toMap`, `fromMap`, `toJson`, and `fromJson` methods for serialization.

4. lib/common/models/user.dart
   - Removed commented out `UserType type;` and related code.
   - Simplified constructor initialization.

5. lib/common/singletons/app_settings.dart
   - Refactored `AppSettings` to remove singleton pattern, allowing for direct instantiation.

6. lib/common/singletons/current_user.dart
   - Refactored `CurrentUser` to remove singleton pattern, allowing for direct instantiation.
   - Added `logout` method to handle user logout.

7. lib/common/singletons/search_filter.dart
   - Refactored `SearchFilter` to remove singleton pattern, allowing for direct instantiation.
   - Added `dispose` method to clean up resources.

8. lib/common/singletons/search_history.dart
   - Refactored `SearchHistory` to remove singleton pattern, allowing for direct instantiation.

9. lib/components/custom_drawer/custom_drawer.dart
   - Updated imports and added dependency injection with `getIt`.
   - Refactored navigation methods to use `jumpToPage` from `BaseController`.
   - Enhanced `ListTile` widgets to conditionally enable/disable based on user login status.

10. lib/components/custom_drawer/widgets/custom_drawer_header.dart
    - Updated imports and added dependency injection with `getIt`.
    - Refactored `isLogin` to `isLoged` for better readability.

11. lib/features/account/account_screen.dart
    - Converted `AccountScreen` to a `StatefulWidget`.
    - Implemented user information display and various action items.

12. lib/features/advertisement/advert_controller.dart
    - Updated imports and added dependency injection with `getIt`.

13. lib/features/base/base_controller.dart
    - Updated imports and added dependency injection with `getIt`.

14. lib/features/base/base_screen.dart
    - Refactored `BaseScreen` to use dependency injection with `getIt`.
    - Removed redundant `_changeToPage` method and updated `CustomDrawer`.

15. lib/features/base/widgets/search_controller.dart
    - Updated imports and added dependency injection with `getIt`.

16. lib/features/base/widgets/search_dialog.dart
    - Updated imports and added dependency injection with `getIt`.

17. lib/features/login/login_controller.dart
    - Updated imports and added dependency injection with `getIt`.

18. lib/features/my_ads/my_ads_controller.dart
    - Added new file with `MyAdsController` extending `BasicController`.
    - Implemented `init`, `getAds`, `getMoreAds`, and `setProductStatus` methods.

19. lib/features/my_ads/my_ads_screen.dart
    - Added new file with `MyAdsScreen` implementing a stateful widget.
    - Integrated `MyAdsController` and implemented UI with tabs for different ad statuses.

20. lib/features/my_ads/my_ads_state.dart
    - Added new file defining `MyAdsState` abstract class and its concrete implementations: `MyAdsStateInitial`, `MyAdsStateLoading`, `MyAdsStateSuccess`, and `MyAdsStateError`.

21. lib/features/my_ads/widgets/my_ad_list_view.dart
    - Added new file implementing `AdListView` widget with scroll and image handling capabilities.

22. lib/features/new_address/new_address_controller.dart
    - Updated imports and added dependency injection with `getIt`.

23. lib/features/shop/shop_controller.dart
    - Updated imports and added dependency injection with `getIt`.

24. lib/features/shop/shop_screen.dart
    - Refactored `ShopScreen` to use dependency injection with `getIt`.
    - Removed redundant `changeToPage` method.

25. lib/features/signup/signup_controller.dart
    - Updated imports and added dependency injection with `getIt`.

26. lib/get_it.dart
    - Added new file to setup and dispose dependencies using `get_it`.

27. lib/main.dart
    - Integrated `get_it` for dependency injection.
    - Updated initialization to use `setupDependencies`.

28. lib/my_material_app.dart
    - Updated imports and added dependency injection with `getIt`.
    - Refactored `initialRoute` and `onGenerateRoute` for better route management.

29. lib/repository/address_repository.dart
    - Added a comment for potential fix regarding `toPointer` usage.

30. lib/repository/advert_repository.dart
    - Added `getMyAds` method to fetch user-specific advertisements.
    - Refactored query logic to use consistent naming conventions.

31. lib/repository/constants.dart
    - Added `keyAddressCreatedAt` constant.

32. lib/repository/parse_to_model.dart
    - Updated `ParseToModel` methods to include `createdAt` property.

33. pubspec.lock
    - Added `get_it` dependency.

34. pubspec.yaml
    - Added `get_it` to dependencies.

Implemented new controllers, refactored singletons to use dependency injection, enhanced UI components, and integrated `get_it` for dependency management, improving state management and overall code maintainability.


## 2024/07/25 - version: 0.5.0+15

This commit introduces enhancements to the Product and Shop screens, adds a new ReadMoreText component, and adjusts the theme colors.

1. lib/common/theme/app_text_style.dart
   - Added new text styles: `font24`, `font24SemiBold`, and `font24Bold`.

2. lib/common/theme/theme.dart
   - Updated various color definitions for better UI consistency: `primaryContainer`, `secondary`, `primaryFixed`, `tertiaryFixedDim`, `onPrimaryFixedVariant`, `surfaceContainer`, and others.

3. lib/components/custom_drawer/custom_drawer.dart
   - Changed the icon for 'Inserir Anúncio' from `Icons.edit` to `Icons.camera`.

4. lib/components/custom_drawer/widgets/custom_drawer_header.dart
   - Wrapped texts in `FittedBox` for better scaling and to ensure the text fits within the designated area.

5. lib/components/customs_text/read_more_text.dart
   - Added the new `ReadMoreText` component for handling expandable text with 'read more' and 'show less' functionality.

6. lib/features/base/base_screen.dart
   - Updated `PageView` children to include `ShopScreen(_changeToPage)` and modified the `ShopScreen` instantiation.

7. lib/features/product/product_screen.dart
   - Converted `ProductScreen` to a `StatefulWidget` to manage animations for floating action buttons.
   - Added a floating action button for contacting the advertiser via phone or chat.
   - Introduced various product detail widgets: `PriceProduct`, `TitleProduct`, `DescriptionProduct`, `LocationProduct`, and `UserCard`.

8. lib/features/product/widgets/description_product.dart
   - Created `DescriptionProduct` widget using the `ReadMoreText` component.

9. lib/features/product/widgets/duo_segmented_button.dart
   - Created `DuoSegmentedButton` widget for segmented button functionality.

10. lib/features/product/widgets/image_carousel.dart
    - Created `ImageCarousel` widget for displaying product images using `carousel_slider`.

11. lib/features/product/widgets/location_product.dart
    - Created `LocationProduct` widget for displaying product location details.

12. lib/features/product/widgets/price_product.dart
    - Created `PriceProduct` widget for displaying product price.

13. lib/features/product/widgets/sub_title_product.dart
    - Created `SubTitleProduct` widget for displaying subtitles in product details.

14. lib/features/product/widgets/title_product.dart
    - Created `TitleProduct` widget for displaying the product title.

15. lib/features/product/widgets/user_card_product.dart
    - Created `UserCard` widget for displaying user information related to the product.

16. lib/features/shop/shop_screen.dart
    - Updated `ShopScreen` to manage animations for floating action buttons.
    - Added a floating action button to navigate to the advertisement screen.

17. lib/features/shop/widgets/ad_list_view.dart
    - Updated `AdListView` to use the shared `ScrollController` for handling list view scroll behavior.
    - Added `InkWell` to navigate to the `ProductScreen` on ad click.

18. lib/features/shop/widgets/ad_text_price.dart
    - Removed unnecessary padding and updated text style for ad price.

19. lib/features/shop/widgets/ad_text_title.dart
    - Removed unnecessary padding and updated text style for ad title.

20. lib/my_material_app.dart
    - Changed default text theme from "Nunito Sans" to "Comfortaa".
    - Updated route handling for `ShopScreen` to pass a callback for page changes.

21. pubspec.yaml and pubspec.lock
    - Added dependency for `carousel_slider` version `4.2.1`.

These changes enhance the user experience by improving the UI consistency, adding new functionalities, and optimizing existing components.


## 2024/07/24 - version: 0.4.2+14

# Commit Message

Refactored Parse Server integration for improved error handling and code maintainability. Changes made:

1. **lib/common/parse_server/errors_mensages.dart**
   - Modified `ParserServerErrors.message` to accept a `String` parameter.
   - Added logic to identify specific error messages.

2. **lib/common/singletons/current_user.dart**
   - Updated method names in `CurrentUser` to align with `AddressManager`.

3. **lib/components/custom_drawer/custom_drawer.dart**
   - Ensured drawer closes after logout.

4. **lib/features/address/address_controller.dart**
   - Updated method calls to match `AddressManager` changes.

5. **lib/features/home/home_controller.dart**
   - Changed method calls in `HomeController` to use `AdvertRepository.get`.

6. **lib/features/login/login_screen.dart**
   - Adjusted error message handling to pass `String`.

7. **lib/features/signup/signup_controller.dart**
   - Separated user signup and state change logic.

8. **lib/features/signup/signup_screen.dart**
   - Updated error handling to pass `String`.

9. **lib/manager/address_manager.dart**
   - Added comments and updated methods for address operations.

10. **lib/manager/mechanics_manager.dart**
    - Added logging and improved error handling.

11. **lib/manager/state_manager.dart**
    - Added comments for clarity.

12. **lib/repository/address_repository.dart**
    - Enhanced logging and exception messages.
    - Updated methods to ensure consistency and clarity.

13. **lib/repository/advert_repository.dart**
    - Improved logging and error handling.
    - Added method comments for better understanding.

14. **lib/repository/ibge_repository.dart**
    - Enhanced logging and exception handling.
    - Added method comments for clarity.

15. **lib/repository/mechanic_repository.dart**
    - Improved logging and error handling.
    - Removed redundant parsing method.

16. **lib/repository/parse_to_model.dart**
    - Added comments to methods for better understanding.
    - Updated parsing logic for `AdvertModel`.

17. **lib/repository/user_repository.dart**
    - Enhanced logging and error handling.
    - Added `_checksPermissions` method to handle ACL settings.

18. **lib/repository/viacep_repository.dart**
    - Enhanced logging and error handling.
    - Updated method to clean CEP and handle exceptions.

This commit refactors various parts of the code related to Parse Server integration. It improves error handling, logging, and overall code maintainability by adding comments and ensuring consistent method usage.


## 2024/07/24 - version: 0.4.1+13

Updated various project files to enhance functionality and improve maintainability.

1. **android/app/build.gradle**
   - Updated `flutterVersionCode` and `flutterVersionName` initialization to include default values.
   - Changed `namespace` and `applicationId`.
   - Added lint options for Java compilation.
   - Added dependency for `ucrop` library.

2. **android/app/src/main/AndroidManifest.xml**
   - Added `package` attribute to the manifest tag.

3. **android/app/src/main/kotlin/com/example/bgbazzar/MainActivity.kt**
   - Updated package name.

4. **android/build.gradle**
   - Added Kotlin version and dependencies.
   - Updated Gradle plugin version.

5. **android/gradle.properties**
   - Added lint option for deprecation warnings.
   - Suppressed unsupported compile SDK warning.

6. **android/gradle/wrapper/gradle-wrapper.properties**
   - Updated Gradle distribution URL.

7. **lib/common/app_info.dart**
   - Created a new file to handle application information and utilities such as URL launching and copying.

8. **lib/common/models/address.dart**
   - Removed unused imports and JSON conversion methods.

9. **lib/common/models/advert.dart**
   - Updated model structure to use `UserModel` for owner and `AddressModel` for address.
   - Reorganized fields.

10. **lib/common/models/filter.dart**
    - Added `setFilter` method to update filter model.

11. **lib/common/models/user.dart**
    - Removed unused imports and JSON conversion methods.

12. **lib/common/parse_server/errors_mensages.dart**
    - Removed logging.

13. **lib/common/singletons/app_settings.dart**
    - Removed unused fields and methods.

14. **lib/common/singletons/search_filter.dart**
    - Created a new singleton to manage search filter state.

15. **lib/common/singletons/search_history.dart**
    - Removed logging.

16. **lib/common/theme/app_text_style.dart**
    - Created a new file to manage application text styles.

17. **lib/common/theme/text_styles.dart** renamed to **lib/common/utils/extensions.dart**
    - Renamed file and converted to manage number and datetime extensions.

18. **lib/components/custom_drawer/custom_drawer.dart**
    - Added a new logout option in the drawer menu.

19. **lib/features/advertisement/advert_controller.dart**
    - Updated model usage for creating advertisements.

20. **lib/features/advertisement/widgets/horizontal_image_gallery.dart**
    - Removed logging.

21. **lib/features/base/base_controller.dart**
    - Integrated `SearchFilter` singleton.
    - Updated search handling methods.

22. **lib/features/base/base_screen.dart**
    - Integrated `SearchFilter` and added actions for search and filter management.

23. **lib/features/base/widgets/search_controller.dart**
    - Removed logging.

24. **lib/features/base/widgets/search_dialog.dart**
    - Removed commented code and logging.

25. **lib/features/base/widgets/search_dialog_bar.dart**
    - Removed logging.

26. **lib/features/filters/widgets/text_title.dart**
    - Updated import to use new text styles.

27. **lib/features/home/home_controller.dart**
    - Integrated `SearchFilter` and updated advertisement fetching logic.

28. **lib/features/home/home_screen.dart**
    - Integrated `AdListView` for displaying advertisements.

29. **lib/features/home/widgets/ad_list_view.dart**
    - Created a new widget to manage advertisement list view.

30. **lib/features/home/widgets/ad_text_info.dart**
    - Created a new widget for displaying advertisement info.

31. **lib/features/home/widgets/ad_text_price.dart**
    - Created a new widget for displaying advertisement price.

32. **lib/features/home/widgets/ad_text_subtitle.dart**
    - Created a new widget for displaying advertisement subtitle.

33. **lib/features/home/widgets/ad_text_title.dart**
    - Created a new widget for displaying advertisement title.

34. **lib/features/signup/signup_screen.dart**
    - Removed logging.

35. **lib/my_material_app.dart**
    - Added localization support.
    - Removed logging.

36. **lib/repository/address_repository.dart**
    - Refactored to use `ParseToModel` for model conversion.
    - Removed redundant logging.

37. **lib/repository/advert_repository.dart**
    - Refactored to use `ParseToModel` for model conversion.
    - Added pagination support for fetching advertisements.

38. **lib/repository/parse_to_model.dart**
    - Created a new utility class for converting Parse objects to models.

39. **lib/repository/user_repository.dart**
    - Refactored to use `ParseToModel` for model conversion.
    - Added logout method.

40. **linux/flutter/generated_plugin_registrant.cc**
    - Added URL launcher plugin registration.

41. **linux/flutter/generated_plugins.cmake**
    - Added URL launcher plugin.

42. **macos/Flutter/GeneratedPluginRegistrant.swift**
    - Added URL launcher and SQLite plugins registration.

43. **pubspec.lock**
    - Updated dependencies and added new ones for cached network image, URL launcher, SQLite, and localization support.

44. **pubspec.yaml**
    - Updated version and added new dependencies for cached network image, URL launcher, and localization support.

45. **windows/flutter/generated_plugin_registrant.cc**
    - Added URL launcher plugin registration.

46. **windows/flutter/generated_plugins.cmake**
    - Added URL launcher plugin.

47. **lib/common/models/address.dart**
    - Removed redundant methods `toMap`, `fromMap`, `toJson`, and `fromJson`.

48. **lib/common/models/advert.dart**
    - Consolidated imports and refactored field organization for better readability and maintainability.

49. **lib/common/models/user.dart**
    - Removed redundant methods `toMap`, `fromMap`, `toJson`, and `fromJson`.

50. **lib/common/parse_server/errors_mensages.dart**
    - Streamlined the error message handling by removing the unnecessary logging of errors.

51. **lib/features/home/home_screen.dart**
    - Updated the `HomeScreen` layout and integrated the `AdListView` to improve user experience and performance.

52. **lib/repository/address_repository.dart**
    - Improved exception handling and removed redundant code for better code quality.

53. **lib/repository/advert_repository.dart**
    - Added pagination and improved the handling of search and filter functionality to enhance the user experience.

54. **lib/repository/user_repository.dart**
    - Enhanced user management with a logout method and improved exception handling.

55. **pubspec.lock**
    - Added `intl_utils` and updated various dependencies to ensure compatibility and leverage new features.

56. **pubspec.yaml**
    - Added dependencies for `intl_utils` to facilitate localization and formatting utilities.

This commit finalizes the enhancements to the project by ensuring all necessary changes are included and properly documented. The updates improve the application's functionality, maintainability, and user experience by integrating new dependencies, refactoring code, and enhancing existing features.


## 2024/07/23 - version: 0.3.5+12

Introduced `ProductCondition` Enum and Refactored `Advert` Models.

1. `lib/common/models/advert.dart`
   - Renamed `AdStatus` to `AdvertStatus`.
   - Added new `ProductCondition` enum.
   - Updated `AdvertModel` to include `condition` property with default value `ProductCondition.all`.
   - Modified constructor to initialize `condition`.
   - Updated `toString` method to include `condition`.

2. `lib/common/models/filter.dart`
   - Imported `advert.dart`.
   - Removed `AdvertiserOrder` enum.
   - Updated `FilterModel` to include `condition` property with default value `ProductCondition.all`.
   - Modified constructor to initialize `condition`.
   - Updated `isEmpty`, `toString`, `==`, and `hashCode` methods to include `condition`.

3. `lib/common/models/user.dart`
   - Commented out `UserType` enum.
   - Removed `type` property from `UserModel` and related methods.

4. `lib/common/singletons/app_settings.dart`
   - Added `search` property to `AppSettings`.

5. `lib/features/advertisement/advert_controller.dart`
   - Added `_condition` property with default value `ProductCondition.used`.
   - Added getter for `condition`.
   - Updated `saveAdvert` method to include `condition`.
   - Added `setCondition` method.

6. `lib/features/advertisement/widgets/advert_form.dart`
   - Imported `advert.dart`.
   - Updated variable name `controller` to `ctrl`.
   - Added UI components to select product condition.
   - Updated form fields to use `ctrl`.

7. `lib/features/base/base_controller.dart`
   - Updated `search` property to use `app.search`.
   - Updated `setSearch` method to use `app.search`.

8. `lib/features/filters/filters_controller.dart`
   - Imported `advert.dart`.
   - Updated `advertiser` property and related methods to use `condition`.

9. `lib/features/filters/filters_screen.dart`
   - Imported `advert.dart`.
   - Updated UI components to select product condition instead of advertiser.

10. `lib/features/home/home_controller.dart`
    - Imported `filter.dart`.
    - Added `filter` property to `HomeController`.
    - Updated `search` property to use `app.search`.

11. `lib/features/home/home_screen.dart`
    - Imported `advert_repository.dart`.
    - Updated floating action button to perform search using `AdvertRepository`.

12. `lib/repository/advert_repository.dart`
    - Added `getAdvertisements` method to fetch ads based on filter and search criteria.
    - Updated `save` method to include `condition`.
    - Updated `_parserServerToAdSale` method to parse `condition`.

13. `lib/repository/constants.dart`
    - Added `keyAdvertCondition` constant.

14. `lib/repository/user_repository.dart`
    - Commented out `type` property setting and retrieval in `UserRepository`.

15. `lib/features/home/home_screen.dart`
    - Updated the floating action button to fetch advertisements using the new `filter` property in `HomeController`.
    - Updated the navigation to the `FiltersScreen` to pass and receive the updated `filter` property.

16. `lib/repository/advert_repository.dart`
    - Added filtering logic in `getAdvertisements` to consider `ProductCondition`.
    - Ensured all advertisement-related operations include the new `condition` property.
    - Updated parsing logic to correctly handle `condition` values from the server.

These changes enhance the flexibility of the advertisement system by allowing users to filter ads based on the condition of the product. This refactoring also simplifies the advertisement model by consolidating advertiser-related properties into the condition. Introduces the `ProductCondition` enum and refactors several models and controllers to support this new property, enhancing the filtering capabilities of advertisements. 


## 2024/07/22 - version: 0.3.4+10

Add enhancements and refactor filter and home functionalities

1. lib/common/models/filter.dart
   - Imported `foundation.dart` for `listEquals`.
   - Added `minPrice` and `maxPrice` to `FilterModel`.
   - Modified the constructor to initialize `state`, `city`, `sortBy`, `advertiser`, `mechanicsId`, `minPrice`, and `maxPrice` with default values.
   - Added `isEmpty` getter to check if the filter is empty.
   - Overrode `toString`, `==`, and `hashCode` to include `minPrice` and `maxPrice`.

2. lib/components/custon_field_controllers/currency_text_controller.dart
   - Added `decimalDigits` parameter to control the number of decimal places.
   - Updated `_formatter` to use `currency` instead of `simpleCurrency`.
   - Updated `_applyMask` and `currencyValue` methods to use `_getDivisionFactor`.
   - Added `_getDivisionFactor` method to calculate the division factor based on `decimalDigits`.

3. lib/features/filters/filters_controller.dart
   - Imported `filter.dart` and `currency_text_controller.dart`.
   - Added `minPriceController` and `maxPriceController` for handling price input.
   - Updated `init` method to accept an optional `FilterModel`.
   - Added `setInitialValues` method to set initial values for the filter.
   - Updated `submitState` and `submitCity` methods to handle exceptions.
   - Updated `mechUpdateNames` method to use `_joinMechNames`.
   - Removed unnecessary log statements.

4. lib/features/filters/filters_screen.dart
   - Updated constructor to accept a `FilterModel`.
   - Updated `initState` to call `ctrl.init` with the provided filter.
   - Updated `_sendFilter` method to use `ctrl.filter`.
   - Added UI components for min and max price input.
   - Added validation for price range.

5. lib/features/filters/widgets/text_form_dropdown.dart
   - Added `focusNode` parameter to `TextFormDropdown`.

6. lib/features/home/home_controller.dart
   - Removed unused methods and properties related to mechanics.

7. lib/features/home/home_screen.dart
   - Updated the filter button to pass the current filter to the `FiltersScreen`.
   - Removed mechanics-related UI components.

8. lib/features/new_address/new_address_screen.dart
   - Removed commented-out code.

9. lib/my_material_app.dart
   - Updated `onGenerateRoute` to pass the `FilterModel` to the `FiltersScreen`.

10. lib/features/filters/filters_screen.dart
    - Enhanced the `FiltersScreen` UI to include new fields for price range filtering.
    - Added input validation for the price range to ensure logical consistency between min and max prices.
    - Adjusted the `FilterModel` handling to accommodate new fields and ensure existing filter states are preserved during navigation and state changes.

11. lib/features/home/home_controller.dart
    - Simplified the `HomeController` by removing mechanics-related methods and properties, focusing it solely on managing the home screen state.

12. lib/features/home/home_screen.dart
    - Enhanced the filter button functionality to display the current filter state.
    - Simplified the UI by removing mechanics-related buttons, focusing the user interface on the primary filtering functionality.

13. lib/features/new_address/new_address_screen.dart
    - Cleaned up the code by removing commented-out lines, ensuring a cleaner and more maintainable codebase.

14. lib/my_material_app.dart
    - Updated the routing logic to correctly pass and handle `FilterModel` instances when navigating to the `FiltersScreen`.
    - Included additional logging for debugging purposes, ensuring better traceability of filter state throughout the application.

These updates collectively enhance the app's structure and overall architecture, improve user experience through better search and filter functionalities, and maintain consistency across the application codebase. The changes reflect ongoing efforts to provide robust and user-friendly features while ensuring a clean, maintainable, and high-performance application.


## 2024/07/22 - version: 0.3.3+9

Add functionalities and general refactorings

1. Added Makefile:
   - Commands to manage Docker (`docker_up` and `docker_down`).
   - Commands for Flutter clean (`flutter_clean`).
   - Commands for Git operations (`git_cached`, `git_commit`, and `git_push`).

2. Added `FilterModel` in `lib/common/models/filter.dart`:
   - Modeling filters for advertisements.

3. Refactored file and class names:
   - Renamed `lib/common/models/uf.dart` to `lib/common/models/state.dart` and updated class name from `UFModel` to `StateBrModel`.

4. Added `SearchHistory` singleton in `lib/common/singletons/search_history.dart`:
   - Manages search history with SharedPreferences.

5. Added `TextStyles` in `lib/common/theme/text_styles.dart`:
   - Defined common text styles for the application.

6. Updated `advert_screen.dart`:
   - Removed unnecessary logging.
   - Integrated new state management for advertisement creation.

7. Enhanced `BaseController` and `BaseScreen`:
   - Added search functionality and integrated `SearchDialog`.

8. Added `SearchDialogController` and `SearchDialog` widget:
   - Manages search functionality and history display.

9. Added `FiltersController` and `FiltersScreen`:
   - Allows filtering advertisements by location, sorting, and mechanics.

10. Updated `mechanics_manager.dart`:
    - Added methods to retrieve mechanics names by IDs.

11. General updates and bug fixes:
    - Improved state handling and UI updates.
    - Refactored method names for clarity and consistency.

12. Updated `pubspec.yaml` version to 0.3.2+8.

13. Updated `home_screen.dart`:
    - Integrated `HomeController` for state management.
    - Added segmented buttons for mechanics and filter selection.
    - Implemented navigation to `MecanicsScreen` and `FiltersScreen`.

14. Added `home_controller.dart` and `home_state.dart`:
    - Managed home screen state and mechanics selection.

15. Updated `main.dart`:
    - Initialized `SearchHistory` during app startup.

16. Updated `state_manager.dart`:
    - Renamed methods and classes to match updated state model.

17. Updated `my_material_app.dart`:
    - Added route for `FiltersScreen`.

18. Updated `ibge_repository.dart`:
    - Renamed methods and updated to use `StateBrModel`.

19. Added tests for `IbgeRepository` in `ibge_repository_test.dart`:
    - Ensured correct functionality for state and city retrieval.

20. Refactored `home_screen.dart`:
    - Integrated `HomeController` for managing the state.
    - Added segmented buttons for mechanics and filter selection.
    - Implemented navigation to `MecanicsScreen` and `FiltersScreen`.

21. Added `home_controller.dart` and `home_state.dart`:
    - Managed the state of the home screen.
    - Provided functionality for mechanics selection and updating the view based on the selected mechanics.

22. Updated `main.dart`:
    - Initialized `SearchHistory` during app startup to ensure search functionality is ready when the app launches.

23. Updated `state_manager.dart`:
    - Renamed methods and classes to align with the updated state model, enhancing code readability and consistency.

24. Updated `my_material_app.dart`:
    - Added a route for `FiltersScreen` to integrate the new filter functionality into the app's navigation.

25. Updated `ibge_repository.dart`:
    - Renamed methods to use `StateBrModel` instead of the previous `UFModel`, ensuring consistency with the updated data models.

26. Added tests for `IbgeRepository` in `ibge_repository_test.dart`:
    - Ensured the correct functionality for state and city retrieval, verifying that the refactored code behaves as expected.

27. Refactored `mechanics_manager.dart`:
    - Added methods `nameFromId` and `namesFromIdList` for retrieving mechanic names based on their IDs.
    - Enhanced functionality to manage and retrieve mechanic names, aiding in cleaner code and improved readability.

28. Added `text_styles.dart`:
    - Defined a centralized `TextStyles` class to manage text styles across the app.
    - Simplified text styling management and ensured consistency in text appearance.

29. Added `search_controller.dart` and `search_dialog.dart`:
    - Implemented a custom search controller and dialog for managing search history and suggestions.
    - Enhanced the search experience by providing users with a history of previous searches and suggestions based on input.

30. Refactored `advert_screen.dart`:
    - Removed redundant log statements for a cleaner codebase.
    - Ensured better readability and maintainability of the code.

31. Refactored `base_controller.dart` and `base_screen.dart`:
    - Integrated search functionality into the base screen.
    - Improved navigation and state management within the base screen.

32. Refactored `filters_controller.dart` and `filters_screen.dart`:
    - Enhanced filters management with improved state handling.
    - Provided a user-friendly interface for selecting filters and mechanics.

33. Updated `Makefile`:
    - Added common commands for Docker, Flutter, and Git operations.
    - Simplified development workflows by providing reusable Makefile commands.

34. Updated `pubspec.yaml`:
    - Bumped the version to `0.3.2+8` to reflect the new features and improvements.
    - Ensured dependencies are up to date, supporting the latest features and bug fixes.

35. Added `home_controller.dart` and `home_screen.dart`:
    - Introduced a home controller to manage the state and interactions on the home screen.
    - Implemented UI elements to allow users to filter and select mechanics easily.
    - Enhanced user experience by providing a more interactive and responsive home screen.

36. Added `filters_states.dart`:
    - Defined states for the filters feature to manage loading, success, and error states.
    - Improved state management, making the filters feature more robust and easier to maintain.

37. Added `search_dialog_bar.dart` and `search_dialog_search_bar.dart`:
    - Provided additional search dialog implementations for various UI scenarios.
    - Enhanced search functionality with better UI integration and user experience.

38. Updated `state_manager.dart`:
    - Refactored to use `StateBrModel` instead of `UFModel`.
    - Improved clarity and consistency in naming conventions.

39. Updated `ibge_repository.dart`:
    - Refactored methods to align with the new state model naming conventions.
    - Ensured consistency and clarity in data retrieval methods.

40. Refactored `my_material_app.dart`:
    - Added route for the new `FiltersScreen`.
    - Improved navigation and ensured all new screens are accessible.

41. Updated `ibge_repository_test.dart`:
    - Refactored tests to align with the new `StateBrModel`.
    - Ensured tests remain up-to-date and cover the new functionality.

42. Added `text_styles.dart`:
    - Introduced a centralized file for text styles to ensure consistency across the app.
    - Made it easier to manage and update text styles in one place.

43. Updated `Makefile`:
    - Added commands for Docker operations (`docker_up`, `docker_down`), Flutter operations (`flutter_clean`), and Git operations (`git_cached`, `git_commit`, `git_push`).
    - Simplified and automated common development tasks, improving developer productivity.

44. Updated `search_history.dart`:
    - Implemented a singleton pattern for managing search history.
    - Added methods to save and retrieve search history using `SharedPreferences`.
    - Enhanced search functionality by providing users with suggestions based on their search history.

45. Updated `advert_screen.dart`:
    - Removed unnecessary imports and log statements.
    - Improved readability and maintainability of the code.

46. Updated `base_controller.dart`:
    - Added constants for page titles and methods to manage page navigation and search functionality.
    - Improved the controller's responsibility to manage state and UI updates more effectively.

47. Updated `base_screen.dart`:
    - Introduced a method for handling search dialog interactions.
    - Enhanced the app bar to dynamically display the search bar or title based on the current page.
    - Improved user experience by integrating a search functionality directly into the app bar.

48. Updated `home_screen.dart`:
    - Added segmented buttons for mechanics and filter selection.
    - Integrated new mechanics and filter selection features into the home screen.

49. Updated `mechanics_manager.dart`:
    - Added methods to retrieve mechanic names by their IDs.
    - Improved data handling for mechanics, making it easier to work with mechanic-related data.

50. Updated `state_manager.dart`:
    - Continued to refine state management by ensuring alignment with the new state model.

51. Updated `main.dart`:
    - Added initialization for the `SearchHistory` singleton.
    - Ensured all necessary initializations are done before the app runs.

52. Incremented `pubspec.yaml` version to 0.3.2+8:
    - Reflecting all the changes and additions made in this update cycle.

This commit encompasses multiple additions and refactorings across the project to enhance functionality, improve code clarity, and manage state more effectively. These changes improve the overall structure, enhance user experience with better search and filter functionalities, and maintain consistency across the application. These updates further improve the app's maintainability, performance, and user experience, ensuring that the app remains robust and user-friendly. The comprehensive updates aim to improve the app’s overall architecture, enhance user experience, and maintain a clean and maintainable codebase. The addition of new models, controllers, and screens reflects ongoing efforts to provide robust and user-friendly features. These updates continue to improve the app’s structure, usability, and developer experience by refining existing features, introducing new functionalities, and ensuring consistency across the codebase.


## 2024/07/18 - version: 0.3.1+7

feat: Refactor and enhance advertisement and mechanic modules

- **lib/common/models/category.dart** to **lib/common/models/mechanic.dart**
  - Renamed `CategoryModel` to `MechanicModel`.

- **lib/components/custon_field_controllers/currency_text_controller.dart**
  - Added `currencyValue` getter to parse the text into a double.

- **lib/features/advertisement/advert_controller.dart**
  - Replaced `CategoryModel` with `MechanicModel`.
  - Added `AdvertState` for state management.
  - Added methods to handle state changes and error handling.

- **lib/features/advertisement/advert_screen.dart**
  - Updated to reflect new state management.
  - Added navigation to `BaseScreen` upon successful ad creation.

- **lib/features/advertisement/advert_state.dart** (new)
  - Added state classes for advertisement management.

- **lib/features/advertisement/widgets/advert_form.dart**
  - Updated to use `selectedMechIds` for mechanics selection.

- **lib/features/base/base_screen.dart**
  - Updated navigation to `AdvertScreen` reflecting new changes.

- **lib/features/mecanics/mecanics_screen.dart**
  - Replaced `categories` with `mechanics`.
  - Updated route name and method names to reflect mechanics instead of categories.

- **lib/manager/mechanics_manager.dart**
  - Replaced `CategoryModel` with `MechanicModel`.

- **lib/repository/advert_repository.dart**
  - Renamed variables to reflect advertisement context.
  - Updated methods to handle the new advert model.

- **lib/repository/constants.dart**
  - Updated constants to reflect advertisement context.

- **lib/repository/mechanic_repository.dart**
  - Renamed methods to reflect mechanics context.

- **pubspec.yaml & pubspec.lock**
  - Updated dependencies versions.
  - Bumped project version to `0.3.1+7`.

- **lib/features/new_address/** (new)
  - **new_address_controller.dart**: Added new address management logic, including form validation and fetching address data from ViaCEP.
  - **new_address_screen.dart**: Created new screen for managing new addresses, including saving and validating address information.
  - **new_address_state.dart**: Added state classes for new address management.
  - **widgets/address_form.dart**: Added new address form for input fields related to address management.

- **lib/features/address/address_controller.dart**
  - Moved logic related to address state management to `AddressManager`.
  - Simplified the controller to delegate address operations to `AddressManager`.

- **lib/features/address/address_screen.dart**
  - Updated screen to utilize `AddressManager` for fetching and managing addresses.
  - Added buttons for adding and removing addresses.

- **lib/manager/address_manager.dart** (new)
  - Added a manager for handling address operations, including saving, deleting, and fetching addresses.
  - Included methods to check for duplicate address names and manage address lists.

These changes collectively refactor the existing advertisement and address modules, introduce better state management, improve the mechanics handling, and streamline address-related operations. Additionally, it includes new features and improvements for handling advertisements and mechanics.


## 2024/07/18 - version: 0.3.0+6

feat: Implement address management with AddressManager and new address screens

- **lib/common/singletons/current_user.dart**
  - Replaced `AddressRepository` with `AddressManager` for managing addresses.
  - Removed `_loadAddresses` method, added `addressByName` and `saveAddress` methods.

- **lib/features/address/address_controller.dart**
  - Simplified `AddressController` to delegate address management to `AddressManager`.
  - Removed form state and validation logic, focusing on address selection and removal.

- **lib/features/address/address_screen.dart**
  - Updated to use new `NewAddressScreen` for adding addresses.
  - Added floating action buttons for adding and removing addresses.

- **lib/features/advertisement/advert_controller.dart**
  - Updated to use `CurrentUser.addressByName` for selecting addresses.

- **lib/features/advertisement/widgets/advert_form.dart**
  - Updated address selection to use `CurrentUser.addressByName`.

- **lib/features/new_address/new_address_controller.dart** (new)
  - Added new controller for managing new address form state and validation.

- **lib/features/new_address/new_address_screen.dart** (new)
  - Added new screen for adding and editing addresses.
  - Integrated `NewAddressController` for form management and submission.

- **lib/features/address/address_state.dart** (renamed to `new_address_state.dart`)
  - Renamed and updated states to be used by `NewAddressController`.

- **lib/features/address/widgets/address_form.dart** (renamed to `new_address/widgets/address_form.dart`)
  - Updated to use `NewAddressController` for form state management.

- **lib/manager/address_manager.dart** (new)
  - Added new manager for handling address CRUD operations and caching.
  - Implemented methods for saving, deleting, and fetching addresses.

- **lib/my_material_app.dart**
  - Added route for `NewAddressScreen`.
  - Updated `onGenerateRoute` to handle new address route.

- **lib/repository/address_repository.dart**
  - Simplified `saveAddress` method.
  - Added `delete` method for removing addresses.
  - Updated error handling and logging.

- **lib/repository/constants.dart**
  - Updated `keyAddressTable` to `'Addresses'`.

This commit message provides a detailed breakdown of changes made to each file, highlighting the specific updates and improvements in the address management system.


## 2024/07/18 - version: 0.2.3+5

feat: Implement new features for address management and validation

- **lib/common/models/address.dart**
  - Added `operator ==` and `hashCode` methods to `AddressModel` for better address comparison and management.

- **lib/common/singletons/current_user.dart**
  - Updated to load addresses and provide access to address names.
  - Improved logic for address initialization and retrieval.

- **lib/common/validators/validators.dart**
  - Added `AddressValidator` for validating various address fields.
  - Enhanced `Validator.zipCode` to clean and validate the zip code correctly.

- **lib/components/form_fields/custom_form_field.dart**
  - Added `textCapitalization` property to `CustomFormField`.

- **lib/components/form_fields/dropdown_form_field.dart**
  - Added `textCapitalization` and `onSelected` properties to `DropdownFormField`.

- **lib/features/advertisement/widgets/advert_form.dart**
  - Added `textCapitalization` property to `AdvertForm`.

- **lib/features/address/address_controller.dart**
  - Enhanced `AddressController` to manage addresses more efficiently.
  - Added methods for validation and setting the form from addresses.
  - Included `zipFocus` to manage focus on the zip code field.

- **lib/features/address/address_screen.dart**
  - Updated `AddressScreen` to validate and save addresses upon leaving the screen.
  - Integrated `PopScope` to handle back navigation and save address changes.

- **lib/features/address/widgets/address_form.dart**
  - Updated `AddressForm` to use `AddressValidator`.
  - Added logic to initialize address types from `CurrentUser`.

- **lib/features/advertisement/advertisement_controller.dart**
  - Renamed `AdvertisementController` to `AdvertController`.
  - Updated methods for address handling and validation.

- **lib/features/advertisement/advertisement_screen.dart**
  - Renamed `AdvertisementScreen` to `AdvertScreen`.

- **lib/features/advertisement/widgets/advertisement_form.dart**
  - Renamed `AdvertisementForm` to `AdvertForm`.
  - Updated address selection logic.

- **lib/features/advertisement/widgets/image_list_view.dart**
  - Updated to use `AdvertController` instead of `AdvertisementController`.

- **lib/features/base/base_screen.dart**
  - Updated route for `AdvertScreen`.

- **lib/features/mecanics/mecanics_screen.dart**
  - Updated `MecanicsScreen` to handle null descriptions gracefully.

- **lib/my_material_app.dart**
  - Updated routes to use `AdvertScreen`.

- **lib/repository/ad_repository.dart**
  - Renamed `AdRepository` to `AdvertRepository`.

- **lib/repository/address_repository.dart**
  - Enhanced `saveAddress` method to handle address name uniqueness per user.
  - Added `_getAddressByName` to fetch addresses by name.
  - Improved error handling and logging.

- **lib/repository/constants.dart**
  - Updated `keyAddressTable` to `'Addresses'`.

This commit message provides a detailed breakdown of changes made to each file, highlighting the specific updates and improvements.


## 2024/07/17 - version: 0.2.2+4

feat: Implement new features for address management, category handling, and insert functionality

- **lib/common/models/address.dart**
  - Added `operator ==` and `hashCode` methods to `AddressModel` for better address management.

- **lib/common/singletons/current_user.dart**
  - Updated to load addresses and provide access to address names.

- **lib/common/validators/validators.dart**
  - Added `AddressValidator` for validating various address fields.
  - Improved `Validator.zipCode` to clean and validate the zip code correctly.

- **lib/components/form_fields/custom_form_field.dart**
  - Added `textCapitalization` property to `CustomFormField`.

- **lib/components/form_fields/dropdown_form_field.dart**
  - Added `textCapitalization` and `onSelected` properties to `DropdownFormField`.

- **lib/features/address/address_controller.dart**
  - Enhanced `AddressController` to manage addresses more efficiently.
  - Added methods for validation and setting the form from addresses.
  - Added `zipFocus` to manage focus on the zip code field.

- **lib/features/address/address_screen.dart**
  - Updated `AddressScreen` to validate and save addresses upon leaving the screen.
  - Included `PopScope` to handle back navigation.

- **lib/features/address/widgets/address_form.dart**
  - Updated `AddressForm` to use `AddressValidator`.
  - Added logic to initialize address types from `CurrentUser`.

- **lib/features/advertisement/advertisement_controller.dart**
  - Renamed `AdvertisementController` to `AdvertController`.
  - Updated methods for address handling and validation.

- **lib/features/advertisement/advertisement_screen.dart**
  - Renamed `AdvertisementScreen` to `AdvertScreen`.

- **lib/features/advertisement/widgets/advertisement_form.dart**
  - Renamed `AdvertisementForm` to `AdvertForm`.
  - Updated address selection logic.

- **lib/features/advertisement/widgets/image_list_view.dart**
  - Updated to use `AdvertController` instead of `AdvertisementController`.

- **lib/features/base/base_screen.dart**
  - Updated route for `AdvertScreen`.

- **lib/features/mecanics/mecanics_screen.dart**
  - Updated `MecanicsScreen` to handle null descriptions gracefully.

- **lib/my_material_app.dart**
  - Updated routes to use `AdvertScreen`.

- **lib/repository/ad_repository.dart**
  - Renamed `AdRepository` to `AdvertRepository`.

- **lib/repository/address_repository.dart**
  - Enhanced `saveAddress` method to handle address name uniqueness per user.
  - Added `_getAddressByName` to fetch addresses by name.
  - Improved error handling and logging.

- **lib/repository/constants.dart**
  - Updated `keyAddressTable` to `'Addresses'`.

This commit message provides a detailed breakdown of changes made to each file, highlighting the specific updates and improvements.


## 2024/07/17 - version: 0.2.1+3:

feat: Address management updates and enhancements

This commit introduces several new features and updates to address management within the application. Key changes include:

- Added unique name verification for addresses per user.
- Implemented logic to handle address creation and updates.
- Enhanced error handling and response validation.
- Included additional model fields for address details.

Detailed Changes:
- lib/common/models/address.dart: Added new model for addresses.
- lib/common/models/category.dart: Renamed CategoryModel to MechanicModel.
- lib/common/models/city.dart: Added new model for city information.
- lib/common/models/uf.dart: Added new model for state information.
- lib/common/models/user.dart: Updated user model with address-related fields.
- lib/common/models/viacep_address.dart: Added model for ViaCEP address information.
- lib/common/singletons/app_settings.dart: Adjusted settings for address handling.
- lib/common/singletons/current_user.dart: Added singleton for current user with address information.
- lib/common/validators/validators.dart: Added validation rules for address fields.
- lib/components/buttons/big_button.dart: Added focus node for address input.
- lib/components/custom_drawer/custom_drawer.dart: Integrated current user for address display.
- lib/components/custom_drawer/widgets/custom_drawer_header.dart: Updated drawer header with address info.
- lib/components/form_fields/custom_form_field.dart: Added new fields for address input.
- lib/components/others_widgets/custom_input_formatter.dart: Added custom input formatter for address fields.
- lib/features/address/address_controller.dart: Added controller for address management.
- lib/features/address/address_screen.dart: Added screen for address input and display.
- lib/features/address/address_state.dart: Added state management for address operations.
- lib/features/insert/insert_controller.dart: Enhanced insert functionality with address handling.
- lib/features/insert/insert_screen.dart: Updated insert screen with address fields.
- lib/features/insert/widgets/image_gallery.dart: Renamed to horizontal_image_gallery.dart.
- lib/features/insert/widgets/insert_form.dart: Integrated address fields into insert form.
- lib/features/login/login_controller.dart: Integrated address handling in login process.
- lib/features/mecanics/mecanics_screen.dart: Added screen for mechanics selection.
- lib/main.dart: Integrated address management on app startup.
- lib/manager/mechanics_manager.dart: Added manager for mechanics data.
- lib/manager/uf_manager.dart: Added manager for state data.
- lib/my_material_app.dart: Updated material app with new routes and address handling.
- lib/repository/address_repository.dart: Added repository for address data handling.
- lib/repository/constants.dart: Updated constants for address fields.
- lib/repository/ibge_repository.dart: Added repository for state and city data.
- lib/repository/mechanic_repository.dart: Renamed from category_repository and updated for mechanics data.
- lib/repository/user_repository.dart: Updated user repository with address handling.
- lib/repository/viacep_repository.dart: Added repository for ViaCEP data.
- pubspec.yaml: Added dependencies for address management.
- test/repository/ibge_repository_test.dart: Added tests for IBGE repository.

This commit significantly enhances the application's ability to manage user addresses, providing a robust framework for address-related data and operations.



## 2024/07/12 - version: 0.2.0+2:

feat: Implemented new features for address management, category handling, and insert functionality

This commit introduces several new features and updates, including address management, category handling, and enhancements to the insert functionality. It also includes modifications to existing models and components to support the new functionality.


Detailed Changes:

- lib/common/models/address.dart:
  - Created a new `AddressModel` to handle address-related data.
  - Implemented methods for serialization and deserialization (`toMap`, `fromMap`, `toJson`, `fromJson`).
  - Added a `toString` method for debugging and logging purposes.

- lib/common/models/category.dart:
  - Renamed `CategoryModel` to `MechanicModel`.
  - Updated class references to reflect the new name.

- lib/common/models/city.dart:
  - Created a new `CityModel` to represent city data.
  - Included methods for serialization and deserialization (`toMap`, `fromMap`, `toJson`, `fromJson`).
  - Added a `toString` method for debugging and logging purposes.

- lib/common/models/uf.dart:
  - Created `RegionModel` and `UFModel` to represent region and state data.
  - Included methods for serialization and deserialization (`toMap`, `fromMap`, `toJson`, `fromJson`).
  - Added `toString` methods for debugging and logging purposes.

- lib/common/models/user.dart:
  - Added serialization and deserialization methods (`toMap`, `fromMap`, `toJson`, `fromJson`).
  - Implemented a `copyFromUserModel` method for cloning user instances.

- lib/common/models/viacep_address.dart:
  - Created a new `ViaCEPAddressModel` to handle address data from the ViaCEP API.
  - Included methods for serialization and deserialization (`toMap`, `fromMap`, `toJson`, `fromJson`).
  - Added a `toString` method for debugging and logging purposes.

- lib/common/singletons/app_settings.dart:
  - Removed user-related properties and methods to simplify the singleton class.

- lib/common/singletons/current_user.dart:
  - Created a new `CurrentUser` singleton to manage the current user and their address.
  - Included methods for initializing and loading user and address data (`init`, `_loadUserAndAddress`).

- lib/common/validators/validators.dart:
  - Added new validators for form fields (`title`, `description`, `mechanics`, `address`, `zipCode`, `cust`).

- lib/components/buttons/big_button.dart:
  - Added `focusNode` property to manage focus state for the button.

- lib/components/custom_drawer/custom_drawer.dart:
  - Updated to use `CurrentUser` for login status checks.

- lib/components/custom_drawer/widgets/custom_drawer_header.dart:
  - Updated to use `CurrentUser` for displaying user information.

- lib/components/form_fields/custom_form_field.dart:
  - Added `readOnly`, `suffixIcon`, and `errorText` properties to enhance form field functionality.

- lib/components/others_widgets/custom_input_formatter.dart:
  - Created a new `CustomInputFormatter` to format text input based on a provided mask.

- lib/features/address/address_controller.dart:
  - Created a new `AddressController` to manage address-related state and logic.
  - Implemented methods for handling address retrieval and saving (`getAddress`, `saveAddressFrom`, `_checkZipCodeReady`).

- lib/features/address/address_screen.dart:
  - Created a new `AddressScreen` to provide a UI for managing user addresses.
  - Integrated with `AddressController` to handle form submission and state changes.

- lib/features/address/address_state.dart:
  - Defined different states for address-related operations (`AddressStateInitial`, `AddressStateLoading`, `AddressStateSuccess`, `AddressStateError`).

- lib/common/models/address.dart:
  - Created `AddressModel` to manage address-related data.
  - Implemented methods for serialization and deserialization (`toMap`, `fromMap`, `toJson`, `fromJson`).

- lib/common/models/category.dart:
  - Renamed `CategoryModel` to `MechanicModel`.
  - Updated class references to reflect the new name.

- lib/common/models/city.dart:
  - Created `CityModel` to represent city data.
  - Included methods for serialization and deserialization (`toMap`, `fromMap`, `toJson`, `fromJson`).

- lib/common/models/uf.dart:
  - Created `RegionModel` and `UFModel` to represent region and state data.
  - Included methods for serialization and deserialization (`toMap`, `fromMap`, `toJson`, `fromJson`).

- lib/common/models/user.dart:
  - Added serialization and deserialization methods (`toMap`, `fromMap`, `toJson`, `fromJson`).
  - Implemented a `copyFromUserModel` method for cloning user instances.

- lib/common/models/viacep_address.dart:
  - Created `ViaCEPAddressModel` to handle address data from the ViaCEP API.
  - Included methods for serialization and deserialization (`toMap`, `fromMap`, `toJson`, `fromJson`).

- lib/common/singletons/app_settings.dart:
  - Removed user-related properties and methods to simplify the singleton class.

- lib/common/singletons/current_user.dart:
  - Created a new `CurrentUser` singleton to manage the current user and their address.
  - Included methods for initializing and loading user and address data (`init`, `_loadUserAndAddress`).

- lib/common/validators/validators.dart:
  - Added new validators for form fields (`title`, `description`, `mechanics`, `address`, `zipCode`, `cust`).

- lib/components/buttons/big_button.dart:
  - Added `focusNode` property to manage focus state for the button.

- lib/components/custom_drawer/custom_drawer.dart:
  - Updated to use `CurrentUser` for login status checks.

- lib/components/custom_drawer/widgets/custom_drawer_header.dart:
  - Updated to use `CurrentUser` for displaying user information.

- lib/components/form_fields/custom_form_field.dart:
  - Added `readOnly`, `suffixIcon`, and `errorText` properties to enhance form field functionality.

- lib/components/others_widgets/custom_input_formatter.dart:
  - Created a new `CustomInputFormatter` to format text input based on a provided mask.

- lib/features/address/address_controller.dart:
  - Created a new `AddressController` to manage address-related state and logic.
  - Implemented methods for handling address retrieval and saving (`getAddress`, `saveAddressFrom`, `_checkZipCodeReady`).

- lib/features/address/address_screen.dart:
  - Created a new `AddressScreen` to provide a UI for managing user addresses.
  - Integrated with `AddressController` to handle form submission and state changes.

- lib/features/address/address_state.dart:
  - Defined different states for address-related operations (`AddressStateInitial`, `AddressStateLoading`, `AddressStateSuccess`, `AddressStateError`).

- lib/features/insert/insert_controller.dart:
  - Enhanced `InsertController` with new methods and properties for managing categories and images.
  - Added methods for form validation (`formValidate`) and managing selected categories (`getCategoriesIds`).

- lib/features/insert/insert_screen.dart:
  - Updated to initialize address data from `CurrentUser`.
  - Added logic for handling form submission (`_createAnnounce`).

- lib/features/insert/widgets/horizontal_image_gallery.dart:
  - Renamed from `image_gallery.dart`.
  - Updated widget structure to handle horizontal image gallery.

- lib/features/insert/widgets/insert_form.dart:
  - Enhanced to include additional fields and validation logic.
  - Integrated navigation for adding mechanics and addresses.

- lib/features/login/login_controller.dart:
  - Updated to use `CurrentUser` for managing login state.

- lib/features/mecanics/mecanics_screen.dart:
  - Created a new `MecanicsScreen` to handle mechanic selection.

- lib/main.dart:
  - Updated main entry point to initialize `CurrentUser` and other managers.
  - Added new routes for address and mechanic screens.

- lib/manager/mechanics_manager.dart:
  - Created `MechanicsManager` to manage mechanic data.
  - Implemented methods for initialization and data retrieval.

- lib/manager/uf_manager.dart:
  - Created `UFManager` to manage state (UF) data.
  - Implemented methods for initialization and data retrieval.

- lib/my_material_app.dart:
  - Added new routes for address and mechanic screens.
  - Updated to support dynamic route generation for mechanic screen.

- lib/repository/address_repository.dart:
  - Created `AddressRepository` to manage address-related data operations.
  - Implemented methods for saving and retrieving address data from both local storage and the server.

- lib/repository/constants.dart:
  - Updated constants to support new address and mechanic data models.

- lib/repository/ibge_repository.dart:
  - Created `IbgeRepository` to manage data retrieval from the IBGE API.
  - Implemented methods for retrieving state and city data.

- lib/repository/mechanic_repository.dart:
  - Renamed from `category_repositories.dart`.
  - Updated to support new mechanic data model.


- lib/common/models/address.dart:
  - Created `AddressModel` to manage address-related data.
  - Implemented methods for serialization and deserialization (`toMap`, `fromMap`, `toJson`, `fromJson`).

- lib/common/models/category.dart:
  - Renamed `CategoryModel` to `MechanicModel`.
  - Updated class references to reflect the new name.

- lib/common/models/city.dart:
  - Created `CityModel` to represent city data.
  - Included methods for serialization and deserialization (`toMap`, `fromMap`, `toJson`, `fromJson`).

- lib/common/models/uf.dart:
  - Created `RegionModel` and `UFModel` to represent region and state data.
  - Included methods for serialization and deserialization (`toMap`, `fromMap`, `toJson`, `fromJson`).

- lib/common/models/user.dart:
  - Added serialization and deserialization methods (`toMap`, `fromMap`, `toJson`, `fromJson`).
  - Implemented a `copyFromUserModel` method for cloning user instances.

- lib/common/models/viacep_address.dart:
  - Created `ViaCEPAddressModel` to handle address data from the ViaCEP API.
  - Included methods for serialization and deserialization (`toMap`, `fromMap`, `toJson`, `fromJson`).

- lib/common/singletons/app_settings.dart:
  - Removed user-related properties and methods to simplify the singleton class.

- lib/common/singletons/current_user.dart:
  - Created a new `CurrentUser` singleton to manage the current user and their address.
  - Included methods for initializing and loading user and address data (`init`, `_loadUserAndAddress`).

- lib/common/validators/validators.dart:
  - Added new validators for form fields (`title`, `description`, `mechanics`, `address`, `zipCode`, `cust`).

- lib/components/buttons/big_button.dart:
  - Added `focusNode` property to manage focus state for the button.

- lib/components/custom_drawer/custom_drawer.dart:
  - Updated to use `CurrentUser` for login status checks.

- lib/components/custom_drawer/widgets/custom_drawer_header.dart:
  - Updated to use `CurrentUser` for displaying user information.

- lib/components/form_fields/custom_form_field.dart:
  - Added `readOnly`, `suffixIcon`, and `errorText` properties to enhance form field functionality.

- lib/components/others_widgets/custom_input_formatter.dart:
  - Created a new `CustomInputFormatter` to format text input based on a provided mask.

- lib/features/address/address_controller.dart:
  - Created a new `AddressController` to manage address-related state and logic.
  - Implemented methods for handling address retrieval and saving (`getAddress`, `saveAddressFrom`, `_checkZipCodeReady`).

- lib/features/address/address_screen.dart:
  - Created a new `AddressScreen` to provide a UI for managing user addresses.
  - Integrated with `AddressController` to handle form submission and state changes.

- lib/features/address/address_state.dart:
  - Defined different states for address-related operations (`AddressStateInitial`, `AddressStateLoading`, `AddressStateSuccess`, `AddressStateError`).

- lib/features/insert/insert_controller.dart:
  - Enhanced `InsertController` with new methods and properties for managing categories and images.
  - Added methods for form validation (`formValidate`) and managing selected categories (`getCategoriesIds`).

- lib/features/insert/insert_screen.dart:
  - Updated to initialize address data from `CurrentUser`.
  - Added logic for handling form submission (`_createAnnounce`).

- lib/features/insert/widgets/horizontal_image_gallery.dart:
  - Renamed from `image_gallery.dart`.
  - Updated widget structure to handle horizontal image gallery.

- lib/features/insert/widgets/insert_form.dart:
  - Enhanced to include additional fields and validation logic.
  - Integrated navigation for adding mechanics and addresses.

- lib/features/login/login_controller.dart:
  - Updated to use `CurrentUser` for managing login state.

- lib/features/mecanics/mecanics_screen.dart:
  - Created a new `MecanicsScreen` to handle mechanic selection.

- lib/main.dart:
  - Updated main entry point to initialize `CurrentUser` and other managers.
  - Added new routes for address and mechanic screens.

- lib/manager/mechanics_manager.dart:
  - Created `MechanicsManager` to manage mechanic data.
  - Implemented methods for initialization and data retrieval.

- lib/manager/uf_manager.dart:
  - Created `UFManager` to manage state (UF) data.
  - Implemented methods for initialization and data retrieval.

- lib/my_material_app.dart:
  - Added new routes for address and mechanic screens.
  - Updated to support dynamic route generation for mechanic screen.

- lib/repository/address_repository.dart:
  - Created `AddressRepository` to manage address-related data operations.
  - Implemented methods for saving and retrieving address data from both local storage and the server.

- lib/repository/constants.dart:
  - Updated constants to support new address and mechanic data models.

- lib/repository/ibge_repository.dart:
  - Created `IbgeRepository` to manage data retrieval from the IBGE API.
  - Implemented methods for retrieving state and city data.

- lib/repository/mechanic_repository.dart:
  - Renamed from `category_repositories.dart`.
  - Updated to support new mechanic data model.

- lib/repository/user_repository.dart:
  - Updated to use correct generic types for getting user attributes.

- lib/repository/viacep_repository.dart:
  - Created `ViacepRepository` to handle address data retrieval from ViaCEP API.
  - Implemented methods for fetching address data based on CEP (postal code).

- pubspec.yaml:
  - Added new dependencies for `http` and `shared_preferences` to support address and data handling.

- test/repository/ibge_repository_test.dart:
  - Added tests for `IbgeRepository` to ensure correct data retrieval from IBGE API.

This commit significantly enhances the application's ability to manage user addresses, categories, and insert functionalities, providing a robust framework for address-related data and operations.


## 2024/07/12 - version: 0.1.0+1:

Implemented InsertForm widget, updated dependencies, and made platform-specific changes

This commit introduces a new InsertForm widget, updates various project dependencies, and includes necessary platform-specific changes to ensure compatibility and functionality.

Detailed Changes:

- lib/ui/form/insert_form.dart:
  - Created a new stateful widget `InsertForm` to handle user inputs.
  - Added `InsertController` as a required parameter for managing form data.
  - Implemented `CustomFormField` components for title and description inputs with `labelText`, `fullBorder`, and `floatingLabelBehavior` properties.
  - Added a `DropdownButtonFormField` for category selection with predefined items.
  - Included a `ValueNotifier<bool>` named `hidePhone` to manage the visibility of the phone number input.
  - Overridden the `dispose` method to properly dispose of the `ValueNotifier`.

- pubspec.yaml:
  - Added `intl: ^0.19.0` for internationalization support.
  - Added `image_picker: ^1.1.2` to enable image selection from the device.
  - Added `image_cropper: ^4.0.1` for cropping images.

- lib/common/models/category.dart:
  - Defined a Category model to encapsulate the data structure and provide methods for handling category-related data.

- lib/components/custom_drawer/custom_drawer.dart:
  - Developed a CustomDrawer widget to standardize the navigation drawer across the application.
  - Included links to major sections such as Home, Insert, and Settings.

- lib/components/form_fields/custom_form_field.dart:
  - Created a reusable CustomFormField widget to ensure consistent styling and functionality across all form fields.

- lib/controllers/insert_controller.dart:
  - Implemented the InsertController class to manage form state and business logic, ensuring separation of concerns and easier testing.

- lib/main.dart:
  - Main entry point updated to include routing and integration for the new InsertForm functionality.

- lib/screens/home_screen.dart:
  - Added navigation logic to transition from the HomeScreen to the new InsertScreen.

- lib/screens/insert_screen.dart:
  - Created InsertScreen to host the InsertForm widget, integrating it into the application's navigation flow.

- lib/services/file_service.dart:
  - Implemented FileService to abstract file operations such as picking and cropping images, leveraging image_picker and image_cropper plugins.

- lib/utilities/constants.dart:
  - Updated constants to support new form and file handling features, ensuring consistent usage across the application.

- windows/flutter/generated_plugin_registrant.cc:
  - Registered `FileSelectorWindows` plugin to handle file selection on Windows.

This commit enhances the form handling capabilities of the application by introducing a new, robust InsertForm widget. It also extends the app's functionality by adding new dependencies for internationalization and image handling. The platform-specific changes ensure that these features are fully supported on Windows, providing a consistent and seamless user experience across different environments.
