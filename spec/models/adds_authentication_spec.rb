describe AddsAuthentication do

  let (:user) { stub(authentications: stub) }

  it "adds an oauth authentication" do
    user.authentications.stub(where: [])
    user.authentications.should_receive(:create!)
    AddsAuthentication.new(user).from_oauth(mock_google_omniauth)
  end

  it "updates an existing oauth authentication" do
    authentication = stub
    user.authentications.stub(where: [ authentication ])
    authentication.should_receive(:update_attributes!)
    AddsAuthentication.new(user).from_oauth(mock_google_omniauth)
  end

end
