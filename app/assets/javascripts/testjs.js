<form id="searchForm" action="javascript:search();">
   <div class="input-group">
      <button id="go" class="btn btn-default" type="button" 
              onclick="document.getElementById('searchForm').submit(); return false;">
      </button>
      <input type="text" id="searchItem" class="form-control" placeholder="Suchbegriff">
   </div>
</form>