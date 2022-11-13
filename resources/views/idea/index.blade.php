<head></head>
<body>
    <table>
        <th>Email</th>
        <th>Titre</th>
        <th>Texte</th>
        <th>Likes</th>
        @foreach($ideas as $idea)
            @include('idea.partials.view')
      @endforeach
    </table>
    @include('idea.partials.create')
</body>
