abstract class RemoteArticlesEvent {
  const RemoteArticlesEvent();
}

class GetArticles extends RemoteArticlesEvent {
  const GetArticles();
}

class GetFirestoreArticles extends RemoteArticlesEvent {
  const GetFirestoreArticles();
}
