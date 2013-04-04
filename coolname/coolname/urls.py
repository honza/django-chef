from django.conf.urls import patterns, include, url

from django.contrib import admin
admin.autodiscover()

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'coolname.views.home', name='home'),
    # url(r'^coolname/', include('coolname.foo.urls')),

    url(r'^admin/', include(admin.site.urls)),
)
