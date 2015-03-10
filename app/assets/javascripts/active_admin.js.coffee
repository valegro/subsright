#= require active_admin/base
#= require tinymce

tinyMCE.init({ selector: 'textarea.tinymce', plugins: [ 'charmap', 'paste', 'link' ] });
