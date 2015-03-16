server code <#
namespace Revenj
{
	using System;
	using Revenj.DomainPatterns;
	using Revenj.Extensibility;
	using System.ComponentModel.Composition;
	using SecUser = global::Security.User;

	[Export(typeof(ISystemAspect))]
	internal class SecurityHelperInitializer : ISystemAspect
	{
		public void Initialize(IObjectFactory factory)
		{
			SecurityHelper.Repository = new Lazy<IDataCache<SecUser>>(() => factory.Resolve<IDataCache<SecUser>>());
		}
	}

	public static partial class SecurityHelper
	{
		internal static Lazy<IDataCache<SecUser>> Repository;

		public static SecUser GetUser(this System.Security.Principal.IPrincipal principal)
		{
			return Repository.Value.Find(principal.Identity.Name);
		}
	}
}
#>;
