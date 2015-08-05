/** @jsx React.DOM */


var Mamajamas = Mamajamas || { Components: {} };

(function () {
  'use strict';

  Mamajamas.Components.ListProfilePhoto = React.createClass({

    getInitialState: function() {
      return {
        uploading: false
      };
    },

    componentDidMount: function() {
      var $imgContainer = $(this.refs.profilePictureImage.getDOMNode());
      var $file = $(this.refs.profilePictureFile.getDOMNode());
      var $fileContainer = $(this.refs.profilePhotoFileContainer.getDOMNode());
      var $form = $(this.refs.profilePictureForm.getDOMNode());
      var $this = this;

      $file.fileupload({
        dataType: "json",
        dropZone: $imgContainer,
        pasteZone: $imgContainer,
        maxNumberOfFiles: 1,
        replaceFileInput: false,
        start: function(e) {
          $this.setState({ uploading: true });
        },
        stop: function(e) {
          $this.setState({ uploading: false });
        },
        add: function(e, data) {
          var types = /(\.|\/)(gif|jpe?g|png)$/i;
          var file = data.files[0];
          if (types.test(file.type) || types.test(file.name)) {
            data.submit();
          } else {
            Mamajamas.Context.Notifications.error(
              file.name + " does not appear to be an image file."
            );
          }
        },
        done: function(e, data) {
          var profilePic = data.result.profile_picture;
          $this.props.model.set('profile_photo_url',
                                profilePic.public_list_url);
        }
      });
    },

    ie9orLower: function() {
      BrowserDetect.init();
      return (
        BrowserDetect.browser == 'Explorer' && BrowserDetect.version <= 9
      );
    },

    handleChangePhoto: function() {
      $(this.refs.profilePictureFile.getDOMNode()).trigger('click');
    },

    progressStyle: function() {
      if (this.state.uploading) {
        return { display: 'inline' };
      }
      else {
        return { display: 'none' };
      }
    },

    changePhotoStyle: function() {
      // photo upload not supported in ie9 or lower
      if (this.ie9orLower()) {
        return { display: 'none' };
      } else {
        if (this.state.uploading) {
          return { display: 'none' };
        }
        else {
          return { display: 'block' };
        }
      }
    },

    assetPath: function(name) {
      var path = name;
      if (!path.match("^http"))
        path = Mamajamas.Context.AssetPath + name;
      return path;
    },

    progressBarImage: function() {
      return this.assetPath("progress-bar.gif");
    },

    render: function() {
      var hiddenStyle = {
        display: 'none'
      };

      var alt = this.props.model.get('username') + " profile photo";

      return (
        <form accept-charset="UTF-8" action="/profile"
              className="label-infield"
              encType="multipart/form-data"
              id="frm-create-profile"
              ref="profilePictureForm"
              method="post">
          <div id="profile-photo-file" ref="profilePhotoFileContainer" style={hiddenStyle}>
            <input name="_method" type="hidden" value="put" />
            <input id="profile_profile_picture"
                   ref="profilePictureFile"
                   name="profile[profile_picture]" type="file" />
            <input id="profile_profile_picture_cache"
                   name="profile[profile_picture_cache]" type="hidden" />
          </div>
          <img alt={alt}
               ref="profilePictureImage"
               src={this.props.model.get('profile_photo_url')} />
          <div className="progress-container">
            <a id="bt-upload" className="button bt-light"
               style={this.changePhotoStyle()}
               onClick={this.handleChangePhoto}>
              <span className="ss-camera"></span>&nbsp;Change Photo
            </a>
            <img src={this.progressBarImage()}
                 alt="Progress bar"
                 className="progress"
                 style={this.progressStyle()} />
          </div>
        </form>
      );
    }

  });

})();
