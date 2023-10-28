# Aplikacja do wyświetlania odległości między stacjami

Aplikacja powinna umożliwić wybranie użytkownikowi dwóch stacji z predefiniowanej listy, a następnie wyświetlić odległość między stacjami w kilometrach.

Stacje z nazwami i współrzędnymi geograficznymi powinny być pobierane z API i cachowane przez 24 godziny (aplikacja powinna móc działać w trybie offline). Po tym czasie lista stacji może się zmienić, program powinien to uwzględnić.

Lista stacji może być zrealizowana za pomocą live search, ekranu pomocniczego lub dowolnego innego mechanizmu podpowiadania tekstu w trakcie wprowadzania znaków. Wyszukiwanie odbywa się po słowach kluczowych pobieranych ze słownika station_keywords, a wyświetlane nazwy stacji ze słownika stations posortowane po polu hits.

Aplikacja powinna być napisana w Swift z wykorzystaniem SwiftUI. Cała reszta od ew. zewnętrznych bibliotek po architekturę jest dowolna, ale ich dobór jest istotny z punktu widzenia oceny zadania.

Samo zadanie jest zaproszeniem do eksperymentów – interfejs, nawigacja, ew. dodatkowe ficzery, ogólny wygląd i działanie nie muszą nawiązywać do KOLEO.

# Realizacja

Ekran główny | Wybór stacji | Wpisywanie frazy
--- | --- | ---
![alt text](https://github.com/Decybel07/KOLEO/blob/main/Assets/1.png) | ![alt text](https://github.com/Decybel07/KOLEO/blob/main/Assets/2.png) | ![alt text](https://github.com/Decybel07/KOLEO/blob/main/Assets/3.png)

1. Przy uruchomieniu aplikacji, ta probuje zaktualizować dane o stacjach oraz słowach kluczowych.
    * W przypadku braku internetu lub błędu z serwera, uzywany jest wczesniej cache (max 24h).
    * Zauważyłem, że zapytania zwracają nagłówki `etag`, `Cache-Control` (również na 24h) dlatego uzyłem logiki buforowania zgodną z protokołem HTTP. [(Więcej szczegółów)](https://link-url-here.org](https://developer.apple.com/documentation/foundation/nsurlrequest/cachepolicy/useprotocolcachepolicy)https://developer.apple.com/documentation/foundation/nsurlrequest/cachepolicy/useprotocolcachepolicy)
    * W trakcji aktualizacji danych, wyświetlany jest ekran ładowania
    * W przypadku błędu i braku możliwości wykorzystania cachu, wyswietlany jest ekran z błędem oraz możliwością ponowienia próby
    * Po wyborze obydwu stacji, obliczana i wyświetlana jest odległość między nimi
2. Wybór stacji jest zrealizowany za pomocą przycisku, który wyswietla listę stacji na osobnym ekranie.
    * Użytkownik ma możliwość przeszukiwania listy po przez wpisanie żądanej frazy.
    * Aktualizacja frazy powoduje aktualizacje listy wyświetlanych stacji. Został tutaj użyty mechanizm `debounce`, który wywołuje aktualizacje listy dopiero gdy między wpisywaniem frazy był odstęp minimum 0,25 sekundy
    * Ze względu na dużą ilość danych do przefiltrowania i sortowania, proces ten jest robiony w oddzielnym wątku.
    * Filtrowanie po frazie zostało zrobione w taki sposób aby ignorowało wielkość znaków oraz znaki diakrytyczne.
    * W przypadku braku wyników dla podanej frazy, wyświetlany jest ekran z odpowiednim komunikatem.
    * Kliknięcie wiersz powoduje wybranie stacji i zamknięcie ekranu pomocniczego
3. W projekcie nie wykorzystano zewnętrznych bibliotek ze względu, ze nie było takiej potrzeby i chciałem zachować kod w jak najprostszej postaci.
    * Zapytania do serwera, można wykonywać z użyciem np. Alamofire
4. Ze względu na brak zdefiniowanej w zadaniu minimalnej wersji iOS, zdecydowałem się na 17.0
    * Zmniejszenie minimalnej wersji do 16.0 wymaga jedynie zastąpienia `ContentUnavailableView`
  
# Dodatki

1. Aplikacja wspiera 2 języki (angielski, polski)
2. Aplikacja wspiera oba schematy kolorów (jasny, ciemny)
3. Aplikacja wspiera dynamiczny rozmiar fontu do potrzeb użytkownika
4. Aplikacja uwzględnia preferencje użytkownika (np. użyta jednostka odległości między stacjami)
