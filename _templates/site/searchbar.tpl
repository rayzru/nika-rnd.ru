<div class="mainPageSearchbar noPrint">
    <div class="container">
        <div class="row">
            <div class="col-md-8">
            </div>
            <div class="col-md-4">
                <form method="get" action="/catalog/search" id="search">
                    <input type="text" class="form-control" name="q" value="{$searchQuery}" placeholder="Поиск">
                    <a class="enter" onclick="$('#search').submit();return false;"></a>
                </form>
                <script type="application/javascript">
                    {* literal}
                    $(document).ready(function(){
                        $('#search input').select2({
                            minimumInputLength: 2,
                            multiple: true,
                            quietMillis: 200,
							allowClear: true,
                            createSearchChoice: function(term, data) {
                                if ($(data).filter(function() { return this.text.localeCompare(term)===0; }).length===0) {return {id:0, text:term};}
                            },
                            ajax: {
                                url: "/catalog/fastSearch",
                                dataType: 'json',
                                data: function (term, page) {
                                    return {
                                        term: term, //search term
                                        page_limit: 10 // page size
                                    };
                                },
                                results: function (data, page) {
                                    return { results: data.results };
                                }
                            }
                        }).on("change", function(e) {
                            if (parseInt(e.added.id)) {
                                document.location.href = "/catalog/viewItem/" + e.added.id;
                            } else {
                                $("#search input").select2("val", "");
                                $('#search input').val(e.added.text);
                                $('#search').submit();
                            }
                        });
                    });
                    {/literal *}
                </script>
            </div>
        </div>
    </div>
</div>
