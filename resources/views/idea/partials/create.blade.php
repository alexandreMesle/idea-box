<form action="idea" method="POST">
    @csrf
    <label>Email</label>
    <input name="mail">
    <br>
    <label>Titre</label>
    <input name="titre">
    <br>
    <label>Texte</label>
    <textarea name="texte">
    </textarea>
    <input type="submit" value="Publier">
</form>

